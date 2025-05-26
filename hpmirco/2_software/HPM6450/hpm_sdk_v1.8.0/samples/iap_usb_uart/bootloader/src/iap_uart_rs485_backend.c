#include "board.h"

#include "hpm_clock_drv.h"
#include "hpm_gpiom_drv.h"
#include "hpm_gpio_drv.h"
#include "hpm_uart_drv.h"
#include "hpm_dma_drv.h"
#include "hpm_dmamux_drv.h"

#include "iap.h"
#include "delay.h"
#include "printf.h"
#include "flash_if.h"

#define DEBUG_MODE                     0

#define RS485_UART_BASE                HPM_UART5
#define RS485_UART_IRQ                 IRQn_UART5
#define RS485_UART_CLK                 clock_uart5
#define RS485_DMA_RX_REQ               HPM_DMA_SRC_UART5_RX

#define RS485_RTS_PIN                  HPM_GPIO0, GPIO_DO_GPIOE, 1
#define RS485_DMA_BASE                 HPM_HDMA
#define RS485_DMAMUX_BASE              HPM_DMAMUX
#define RS485_DMA_RX_CHN               1U
#define RS485_DMA_IRQ                  IRQn_HDMA
#define RS485_DMA_IRQ_PRIO             2

#define SHAKE_HAND_A                   0xA1  // request
#define SHAKE_HAND_B                   0xA2  // ack
#define SEND_FILE_READY_A              0xA3  // request
#define SEND_FILE_READY_B              0xA4  // ack
#define SEND_FILE_OVER_B               0xA5  // indication
#define SEND_FILE_CHECK_SDRAM_ERROR    0xA6
#define SEND_FILE_RCV_ERROR            0xA7
#define SEND_FILE_PROGRAMM_FLASH_ERROR 0xA8

#define uart_printf                    printf_
#define uart_putchar                   _putchar

#ifndef min
#define min(a, b) (a < b) ? (a) : (b)
#endif

static const char* errstr = NULL;

#define UART_RXBUF_SIZE (FLASH_SECTOR_SIZE)
#define UART_RXBUF_NUM  2                            // 双缓冲
static uint32_t u32NbrOfRxBytes   = 0;               // 接收的字节数
static uint8_t  u8BusyBlockIndex  = 0;               // 忙碌块索引
static uint8_t  u8ReadyBlockIndex = UART_RXBUF_NUM;  // 就绪块索引

ATTR_PLACE_AT_NONCACHEABLE_WITH_ALIGNMENT(4)
uint8_t au8UartRxBuf[UART_RXBUF_SIZE * UART_RXBUF_NUM] = {0};

void uart_putchar(char ch)
{
    uart_send_byte(RS485_UART_BASE, ch);
}

static void rs485_set_tx_dir(void)
{
    gpio_write_pin(RS485_RTS_PIN, 1);
    board_delay_ms(200);
    uart_reset_tx_fifo(RS485_UART_BASE);
    board_delay_us(200);
}

static void rs485_set_rx_dir(void)
{
    board_delay_us(200);
    gpio_write_pin(RS485_RTS_PIN, 0);
    board_delay_us(200);
    uart_reset_rx_fifo(RS485_UART_BASE);
}

static int uart_try_recvice(void)
{
    uint8_t ch;

    if (uart_try_receive_byte(RS485_UART_BASE, &ch) == status_success)
    {
        return ch;
    }

    return -1;
}

static int uart_recvice_blocking(uint32_t timeout)
{
    uint32_t start_time = u32_GetTick();

    uint8_t ch;

    do
    {
        if (uart_try_receive_byte(RS485_UART_BASE, &ch) == status_success)
        {
            return ch;
        }

        if (E_DelayNonBlock(start_time, timeout) == true)
        {
            return -1;
        }

    } while (1);
}

static void uart_rxdma_enable(void)
{
    dma_handshake_config_t config = {0};

    config.ch_index     = RS485_DMA_RX_CHN;
    config.dst          = core_local_mem_to_sys_address(BOARD_RUNNING_CORE, (uint32_t)&au8UartRxBuf[u8BusyBlockIndex * UART_RXBUF_SIZE]);
    config.dst_fixed    = false;
    config.src          = (uint32_t)&RS485_UART_BASE->RBR;
    config.src_fixed    = true;
    config.data_width   = DMA_TRANSFER_WIDTH_BYTE;
    config.size_in_byte = UART_RXBUF_SIZE;

    dma_setup_handshake(RS485_DMA_BASE, &config, true);
}

static void dma_isr(void)
{
    uint32_t u32RxDmaSts = dma_check_transfer_status(RS485_DMA_BASE, RS485_DMA_RX_CHN);

    if (CHKMSK(u32RxDmaSts, DMA_CHANNEL_STATUS_TC))
    {
        u8ReadyBlockIndex = u8BusyBlockIndex;

        u8BusyBlockIndex++;
        u8BusyBlockIndex %= UART_RXBUF_NUM;
        uart_rxdma_enable();
    }
}

SDK_DECLARE_EXT_ISR_M(RS485_DMA_IRQ, dma_isr);

static bool iap_init(void)
{
    // pimnux
    HPM_IOC->PAD[IOC_PAD_PE24].FUNC_CTL = IOC_PE24_FUNC_CTL_UART5_RXD;  // RS485_RX
    HPM_IOC->PAD[IOC_PAD_PE25].FUNC_CTL = IOC_PE25_FUNC_CTL_UART5_TXD;  // RS485_TX
    HPM_IOC->PAD[IOC_PAD_PE01].FUNC_CTL = IOC_PE01_FUNC_CTL_GPIO_E_01;  // RS485_RTS
    HPM_IOC->PAD[IOC_PAD_PE01].PAD_CTL  = IOC_PAD_PAD_CTL_PE_SET(1) | 0x08 | IOC_PAD_PAD_CTL_DS_SET(6) | IOC_PAD_PAD_CTL_PS_SET(0) | IOC_PAD_PAD_CTL_SMT_SET(0);

    gpiom_set_pin_controller(HPM_GPIOM, GPIOM_ASSIGN_GPIOE, 1, gpiom_soc_gpio0);
    gpio_set_pin_output(RS485_RTS_PIN);

    // init clock
    clock_set_source_divider(RS485_UART_CLK, clk_src_pll1_clk0, 10);
    clock_add_to_group(RS485_UART_CLK, 0);

    // init frame format
    uart_config_t config = {0};
    uart_default_config(RS485_UART_BASE, &config);

    config.baudrate = 115200;
    config.parity           = parity_none;
    config.num_of_stop_bits = stop_bits_1;
    config.word_length      = word_length_8_bits;

    config.src_freq_in_hz = clock_get_frequency(RS485_UART_CLK);
    config.fifo_enable    = true;
    config.tx_fifo_level  = uart_tx_fifo_trg_not_full;
    config.rx_fifo_level  = uart_rx_fifo_trg_gt_one_quarter; // 此处不能使用 uart_rx_fifo_trg_not_empty, 会导致 dma 接收到的第1个字节为 SEND_FILE_READY_A
    config.dma_enable     = true;

    uart_init(RS485_UART_BASE, &config);

    // set rx mode
    rs485_set_rx_dir();

    return true;
}

static bool iap_deinit(void)
{
    dma_reset(RS485_DMA_BASE);
    clock_remove_from_group(RS485_UART_CLK, 0);

    return true;
}

static bool iap_shakehand(void)
{
    static uint8_t shakehand_counter = 0;

    int ch = uart_try_recvice();

    if (ch != SHAKE_HAND_A)
    {
        if (ch != -1)
        {
            shakehand_counter = 0;
        }

        return false;
    }

    if (++shakehand_counter < 32)
    {
        return false;
    }

    // set tx mode
    rs485_set_tx_dir();

    // display version
    uart_printf("> Bios_V0.1\n");
#if DEBUG_MODE
    uart_printf("> +--------------+\n");
    uart_printf("> |  Debug Mode  |\n");
    uart_printf("> +--------------+\n");
#endif
    uart_printf("> build date: " __DATE__ "\n");
    uart_printf("> build time: " __TIME__ "\n");

    // send ack
    uart_putchar(SHAKE_HAND_B);

    // enable rxdma irq
    intc_m_enable_irq_with_priority(RS485_DMA_IRQ, RS485_DMA_IRQ_PRIO);
    dmamux_config(RS485_DMAMUX_BASE, DMA_SOC_CHN_TO_DMAMUX_CHN(RS485_DMA_BASE, RS485_DMA_RX_CHN), RS485_DMA_RX_REQ, true);

    // set rx mode
    rs485_set_rx_dir();

    return true;
}

static uint16_t Verify_ModbusCRC16(uint32_t addr, uint32_t len)
{
    static const uint8_t aucCRCHi[] = {
        0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
        0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
        0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
        0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
        0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
        0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
        0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
        0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
        0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
        0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
        0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
        0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
        0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40,
        0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
        0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40, 0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41,
        0x00, 0xC1, 0x81, 0x40, 0x01, 0xC0, 0x80, 0x41, 0x01, 0xC0, 0x80, 0x41, 0x00, 0xC1, 0x81, 0x40};

    static const uint8_t aucCRCLo[] = {
        0x00, 0xC0, 0xC1, 0x01, 0xC3, 0x03, 0x02, 0xC2, 0xC6, 0x06, 0x07, 0xC7, 0x05, 0xC5, 0xC4, 0x04,
        0xCC, 0x0C, 0x0D, 0xCD, 0x0F, 0xCF, 0xCE, 0x0E, 0x0A, 0xCA, 0xCB, 0x0B, 0xC9, 0x09, 0x08, 0xC8,
        0xD8, 0x18, 0x19, 0xD9, 0x1B, 0xDB, 0xDA, 0x1A, 0x1E, 0xDE, 0xDF, 0x1F, 0xDD, 0x1D, 0x1C, 0xDC,
        0x14, 0xD4, 0xD5, 0x15, 0xD7, 0x17, 0x16, 0xD6, 0xD2, 0x12, 0x13, 0xD3, 0x11, 0xD1, 0xD0, 0x10,
        0xF0, 0x30, 0x31, 0xF1, 0x33, 0xF3, 0xF2, 0x32, 0x36, 0xF6, 0xF7, 0x37, 0xF5, 0x35, 0x34, 0xF4,
        0x3C, 0xFC, 0xFD, 0x3D, 0xFF, 0x3F, 0x3E, 0xFE, 0xFA, 0x3A, 0x3B, 0xFB, 0x39, 0xF9, 0xF8, 0x38,
        0x28, 0xE8, 0xE9, 0x29, 0xEB, 0x2B, 0x2A, 0xEA, 0xEE, 0x2E, 0x2F, 0xEF, 0x2D, 0xED, 0xEC, 0x2C,
        0xE4, 0x24, 0x25, 0xE5, 0x27, 0xE7, 0xE6, 0x26, 0x22, 0xE2, 0xE3, 0x23, 0xE1, 0x21, 0x20, 0xE0,
        0xA0, 0x60, 0x61, 0xA1, 0x63, 0xA3, 0xA2, 0x62, 0x66, 0xA6, 0xA7, 0x67, 0xA5, 0x65, 0x64, 0xA4,
        0x6C, 0xAC, 0xAD, 0x6D, 0xAF, 0x6F, 0x6E, 0xAE, 0xAA, 0x6A, 0x6B, 0xAB, 0x69, 0xA9, 0xA8, 0x68,
        0x78, 0xB8, 0xB9, 0x79, 0xBB, 0x7B, 0x7A, 0xBA, 0xBE, 0x7E, 0x7F, 0xBF, 0x7D, 0xBD, 0xBC, 0x7C,
        0xB4, 0x74, 0x75, 0xB5, 0x77, 0xB7, 0xB6, 0x76, 0x72, 0xB2, 0xB3, 0x73, 0xB1, 0x71, 0x70, 0xB0,
        0x50, 0x90, 0x91, 0x51, 0x93, 0x53, 0x52, 0x92, 0x96, 0x56, 0x57, 0x97, 0x55, 0x95, 0x94, 0x54,
        0x9C, 0x5C, 0x5D, 0x9D, 0x5F, 0x9F, 0x9E, 0x5E, 0x5A, 0x9A, 0x9B, 0x5B, 0x99, 0x59, 0x58, 0x98,
        0x88, 0x48, 0x49, 0x89, 0x4B, 0x8B, 0x8A, 0x4A, 0x4E, 0x8E, 0x8F, 0x4F, 0x8D, 0x4D, 0x4C, 0x8C,
        0x44, 0x84, 0x85, 0x45, 0x87, 0x47, 0x46, 0x86, 0x82, 0x42, 0x43, 0x83, 0x41, 0x81, 0x80, 0x40};

    uint8_t ucCRCHi = 0xFF;
    uint8_t ucCRCLo = 0xFF;
    int     iIndex;

    uint8_t buff[0x100];

    while (len > 0)
    {
        uint16_t size = min(sizeof(buff), len);

        flashif.read(addr, size, buff);

        len -= size;
        addr += size;

        uint8_t* p = &buff[0];

        while (size--)
        {
            iIndex  = ucCRCLo ^ *(p++);
            ucCRCLo = ucCRCHi ^ aucCRCHi[iIndex];
            ucCRCHi = aucCRCLo[iIndex];
        }
    }

    return (ucCRCHi << 8) | ucCRCLo;
}

static bool iap_transfer(void)
{
    int ch;

    //
    // prepare
    //

    ch = uart_recvice_blocking(200);

    if (ch != SEND_FILE_READY_A)
    {
        return false;
    }

    // set tx mode
    rs485_set_tx_dir();

    // earse chip
    if (flashif.earse(FLASH_APP_ADDRESS, APP_MAX_SIZE) == false)
    {
        errstr = "earse flash fail";
        return false;
    }

    // send ack
    uart_putchar(SEND_FILE_READY_B);

    // set rx mode
    rs485_set_rx_dir();

    //
    // program
    //

    uint32_t u32FlashAddress = FLASH_APP_ADDRESS;
    uint32_t u32StartTime    = u32_GetTick();

    u32NbrOfRxBytes  = 0;
    u8BusyBlockIndex = 0;
    uart_rxdma_enable();

    while (1)
    {
        if (u8ReadyBlockIndex < UART_RXBUF_NUM)
        {
            u32NbrOfRxBytes += UART_RXBUF_SIZE;

            if (u32NbrOfRxBytes > APP_MAX_SIZE)
            {
                errstr = "fireware oversize";
            }

            if (errstr == NULL)  // 出错后不再对flash进行编程, 待结束后上报错误
            {
                uint8_t* pu8BlockBuff = &au8UartRxBuf[u8ReadyBlockIndex * UART_RXBUF_SIZE];

                if (flashif.write(u32FlashAddress, UART_RXBUF_SIZE, pu8BlockBuff) == false)
                {
                    errstr = "program flash fail";
                }

                u32FlashAddress += UART_RXBUF_SIZE;
                u8ReadyBlockIndex = UART_RXBUF_NUM;
            }

            u32StartTime = u32_GetTick();
        }
        else if (E_DelayNonBlock(u32StartTime, 1000) == true)
        {
            uint32_t u32RemainBytes = UART_RXBUF_SIZE - dma_get_remaining_transfer_size(RS485_DMA_BASE, RS485_DMA_RX_CHN);

            // stop rxdma
            dma_disable_channel(RS485_DMA_BASE, RS485_DMA_RX_CHN);

            if (u32RemainBytes > 0)
            {
                u32NbrOfRxBytes += u32RemainBytes;

                if (errstr == NULL)  // 出错后不再对flash进行编程, 待结束后上报错误
                {
                    if (u32NbrOfRxBytes > APP_MAX_SIZE)
                    {
                        errstr = "fireware oversize";
                    }
                    else
                    {
                        u8ReadyBlockIndex     = u8BusyBlockIndex;
                        uint8_t* pu8BlockBuff = &au8UartRxBuf[u8ReadyBlockIndex * UART_RXBUF_SIZE];

                        if (flashif.write(u32FlashAddress, u32RemainBytes, pu8BlockBuff) == false)
                        {
                            errstr = "program flash fail";
                        }
                    }
                }
            }

            break;
        }
    }

    // set tx mode
    rs485_set_tx_dir();

    uart_printf("\n");
    uart_printf("> count of bytes received: %d\n", u32NbrOfRxBytes);

    if (errstr == NULL)
    {
        if (u32NbrOfRxBytes == 0)
        {
            errstr = "no bytes receviced";
        }
        else if (Verify_ModbusCRC16(FLASH_APP_ADDRESS, u32NbrOfRxBytes) != 0)
        {
            // tuner 下发固件会在末尾添加 crc
            errstr = "checksum not matach";
        }
    }

    if (errstr == NULL)
    {
        uart_printf("> program success\n");

        // send ack
        uart_putchar(SEND_FILE_OVER_B);

        // waiting uart tx over
        board_delay_ms(100);

        return true;
    }
    else
    {
        // send error reason
        uart_printf("> program fail\n");
        uart_printf("> reason: %s\n", errstr);

        // send ack
        uart_putchar(SEND_FILE_RCV_ERROR);
        uart_putchar(SEND_FILE_RCV_ERROR);
        uart_putchar(SEND_FILE_RCV_ERROR);

        // waiting uart tx over
        board_delay_ms(100);

        return false;
    }
}

iap_if_t iapif_uart_rs485 = {
    .lowlevel_init   = iap_init,
    .lowlevel_deinit = iap_deinit,
    .transfer        = iap_transfer,
    .try_shakehand   = iap_shakehand,
};
