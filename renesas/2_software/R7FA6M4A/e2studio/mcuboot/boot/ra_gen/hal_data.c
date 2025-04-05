/* generated HAL source file - do not edit */
#include "hal_data.h"
qspi_instance_ctrl_t g_qspi0_ctrl;

static const spi_flash_erase_command_t g_qspi0_erase_command_list[] =
{
#if 4096 > 0
  { .command = 0x20, .size = 4096 },
#endif
#if 32768 > 0
  { .command = 0x52, .size = 32768 },
#endif
#if 65536 > 0
  { .command = 0xD8, .size = 65536 },
#endif
#if 0xC7 > 0
  { .command = 0xC7, .size = SPI_FLASH_ERASE_SIZE_CHIP_ERASE },
#endif
        };
static const qspi_extended_cfg_t g_qspi0_extended_cfg =
{ .min_qssl_deselect_cycles = QSPI_QSSL_MIN_HIGH_LEVEL_4_QSPCLK, .qspclk_div = QSPI_QSPCLK_DIV_2, };
const spi_flash_cfg_t g_qspi0_cfg =
{ .spi_protocol = SPI_FLASH_PROTOCOL_EXTENDED_SPI,
  .read_mode = SPI_FLASH_READ_MODE_FAST_READ_QUAD_IO,
  .address_bytes = SPI_FLASH_ADDRESS_BYTES_3,
  .dummy_clocks = SPI_FLASH_DUMMY_CLOCKS_DEFAULT,
  .page_program_address_lines = SPI_FLASH_DATA_LINES_1,
  .page_size_bytes = 256,
  .page_program_command = 0x02,
  .write_enable_command = 0x06,
  .status_command = 0x05,
  .write_status_bit = 0,
  .xip_enter_command = 0x20,
  .xip_exit_command = 0xFF,
  .p_erase_command_list = &g_qspi0_erase_command_list[0],
  .erase_command_list_length = sizeof(g_qspi0_erase_command_list) / sizeof(g_qspi0_erase_command_list[0]),
  .p_extend = &g_qspi0_extended_cfg, };
/** This structure encompasses everything that is needed to use an instance of this interface. */
const spi_flash_instance_t g_qspi0 =
{ .p_ctrl = &g_qspi0_ctrl, .p_cfg = &g_qspi0_cfg, .p_api = &g_qspi_on_spi_flash, };
#define RA_NOT_DEFINED (UINT32_MAX)
#if (RA_NOT_DEFINED) != (g_qspi0)
qspi_instance_ctrl_t * const gp_mcuboot_xspi_ctrl = &g_qspi0_ctrl;
spi_flash_cfg_t const * const gp_mcuboot_xspi_cfg = &g_qspi0_cfg;
spi_flash_instance_t const * const gp_mcuboot_xspi_instance = &g_qspi0;
#endif
#undef RA_NOT_DEFINED
flash_hp_instance_ctrl_t g_flash0_ctrl;
const flash_cfg_t g_flash0_cfg =
{ .data_flash_bgo = false, .p_callback = NULL, .p_context = NULL,
#if defined(VECTOR_NUMBER_FCU_FRDYI)
    .irq                 = VECTOR_NUMBER_FCU_FRDYI,
#else
  .irq = FSP_INVALID_VECTOR,
#endif
#if defined(VECTOR_NUMBER_FCU_FIFERR)
    .err_irq             = VECTOR_NUMBER_FCU_FIFERR,
#else
  .err_irq = FSP_INVALID_VECTOR,
#endif
  .err_ipl = (BSP_IRQ_DISABLED),
  .ipl = (BSP_IRQ_DISABLED), };
/* Instance structure to use this module. */
const flash_instance_t g_flash0 =
{ .p_ctrl = &g_flash0_ctrl, .p_cfg = &g_flash0_cfg, .p_api = &g_flash_on_flash_hp };
void *const gp_mcuboot_flash_ctrl = &g_flash0_ctrl;
flash_cfg_t const *const gp_mcuboot_flash_cfg = &g_flash0_cfg;
flash_instance_t const *const gp_mcuboot_flash_instance = &g_flash0;
void g_hal_init(void)
{
    g_common_init ();
}
