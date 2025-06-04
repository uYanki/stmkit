#include "sw_mdio.h"

#include "hpm_gpio_drv.h"
#include "hpm_gpiom_drv.h"

#define MDIO_CLK_PIN     HPM_GPIO0, GPIO_DI_GPIOA, 22
#define MDIO_DAT_PIN     HPM_GPIO0, GPIO_DI_GPIOA, 25

#define MDIO_CLK_H()     gpio_write_pin(MDIO_CLK_PIN, 1)
#define MDIO_CLK_L()     gpio_write_pin(MDIO_CLK_PIN, 0)

#define MDIO_DAT_H()     gpio_write_pin(MDIO_DAT_PIN, 1)
#define MDIO_DAT_L()     gpio_write_pin(MDIO_DAT_PIN, 0)

#define MDIO_DAT_X()     gpio_read_pin(MDIO_DAT_PIN)

#define MDIO_DAT_IN()    gpio_set_pin_input(MDIO_DAT_PIN)
#define MDIO_DAT_OUT()   gpio_set_pin_output(MDIO_DAT_PIN)

#define MDIO_DELAY_US(t) board_delay_us(t)

static void mdio_write_bit(bool bit)
{
    MDIO_CLK_L();

    if (bit == false)
    {
        MDIO_DAT_L();
    }
    else
    {
        MDIO_DAT_H();
    }

    MDIO_DELAY_US(100);
    MDIO_CLK_H();
    MDIO_DELAY_US(100);
    MDIO_CLK_L();
}

static bool mdio_read_bit(void)
{
    bool bit = 0;

    MDIO_CLK_H();
    MDIO_DELAY_US(100);
    MDIO_CLK_L();
    MDIO_DELAY_US(100);

    if (MDIO_DAT_X() != 0)
    {
        bit = true;
    }
    else
    {
        bit = false;
    }

    return bit;
}

void mdio_write_byte(uint16_t phy_addr, uint16_t reg_addr, uint16_t reg_data)
{
    int i = 0;

    // 设置为输出
    MDIO_DAT_OUT();

    // 发送前导码
    for (i = 0; i < 32; i++)
    {
        mdio_write_bit(1);
    }

    // 发送ST
    mdio_write_bit(0);
    mdio_write_bit(1);

    // 发送OP
    mdio_write_bit(0);
    mdio_write_bit(1);

    // 发送PHY地址
    for (i = 0; i < 5; i++)
    {
        if ((phy_addr & (0x10 >> i)) != 0)
        {
            mdio_write_bit(1);
        }
        else
        {
            mdio_write_bit(0);
        }
    }

    // 发送寄存器地址
    for (i = 0; i < 5; i++)
    {
        if ((reg_addr & (0x10 >> i)) != 0)
        {
            mdio_write_bit(1);
        }
        else
        {
            mdio_write_bit(0);
        }
    }

    // 发送TA
    mdio_write_bit(1);
    mdio_write_bit(0);

    // 发送数据
    for (i = 0; i < 16; i++)
    {
        if ((reg_data & (0x8000 >> i)) != 0)
        {
            mdio_write_bit(1);
        }
        else
        {
            mdio_write_bit(0);
        }
    }

    for (i = 0; i < 32; i++)
    {
        mdio_write_bit(1);
    }
}

uint16_t mdio_read_byte(uint16_t phy_addr, uint16_t reg_addr)
{
    int      i   = 0;
    uint16_t val = 0;

    // 设置为输出
    MDIO_DAT_OUT();

    // 发送前导码
    for (i = 0; i < 32; i++)
    {
        mdio_write_bit(1);
    }

    // 发送ST
    mdio_write_bit(0);
    mdio_write_bit(1);
    // 发送op
    mdio_write_bit(1);
    mdio_write_bit(0);

    // 发送PHY地址
    for (i = 0; i < 5; i++)
    {
        if ((phy_addr & (0x10 >> i)) != 0)
        {
            mdio_write_bit(1);
        }
        else
        {
            mdio_write_bit(0);
        }
    }

    // 发送寄存器地址
    for (i = 0; i < 5; i++)
    {
        if ((reg_addr & (0x10 >> i)) != 0)
        {
            mdio_write_bit(1);
        }
        else
        {
            mdio_write_bit(0);
        }
    }

    // 在这里切换成输入
    MDIO_DAT_IN();

    // 读取OP值
    for (i = 0; i < 2; i++)
    {
        mdio_read_bit();
    }

    i = 0;
    if (MDIO_DAT_X() != 0)
    {
        val |= 1 << (15 - i);
    }
    for (i = 1; i < 16; i++)
    {
        if (mdio_read_bit() != 0)
        {
            val |= 1 << (15 - i);
        }
    }

    MDIO_DAT_OUT();

    // 发送前导码
    for (i = 0; i < 32; i++)
    {
        mdio_write_bit(1);
    }
    return val;
}

void mdio_scan_phy(void)
{
    uint16_t reg = 0x00, data;

    for (uint8_t i = 0; i < 8; ++i)
    {
        // mdio_write_byte(i, reg,0xE);
        data = mdio_read_byte(i, reg);
        printf("addr = %d, data = %02X\n", i, data);
    }
}

void mdio_init(void)
{
    HPM_IOC->PAD[IOC_PAD_PA25].FUNC_CTL = IOC_PA25_FUNC_CTL_GPIO_A_25;
    HPM_IOC->PAD[IOC_PAD_PA22].FUNC_CTL = IOC_PA22_FUNC_CTL_GPIO_A_22;

    gpiom_set_pin_controller(HPM_GPIOM, GPIOM_ASSIGN_GPIOA, 25, gpiom_soc_gpio0);
    gpio_set_pin_output(MDIO_DAT_PIN);

    gpiom_set_pin_controller(HPM_GPIOM, GPIOM_ASSIGN_GPIOA, 22, gpiom_soc_gpio0);
    gpio_set_pin_output(MDIO_CLK_PIN);
}