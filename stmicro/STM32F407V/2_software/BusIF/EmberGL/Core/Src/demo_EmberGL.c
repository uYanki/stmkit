#include "spi_st7735.h"

#if CONFIG_DEMOS_SW

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "EmberGL-demo"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

static spi_mst_t spi = {
		.MISO = {GPIOA, GPIO_PIN_6}, 
		.MOSI = {GPIOA, GPIO_PIN_6}, /*SDA*/
		.SCLK = {GPIOA, GPIO_PIN_5}, /*SCL*/
		.CS   = {GPIOA, GPIO_PIN_4}, /*CS*/
};

static spi_st7735_t st7735 = {
		.hSPI = &spi,
		.DC   = {GPIOA, GPIO_PIN_0 }, /*DC*/
#if CONFIG_ST7735_RST_CONTROL_SW
		.RST  = {GPIOC, GPIO_PIN_0 }, /*RST*/
#endif
#if CONFIG_ST7735_BL_CONTROL_SW
		.BL   = {GPIOC, GPIO_PIN_13}, /*BL*/
#endif
		.u16ScreenW = ST7735_WIDTH,
		.u16ScreenH = ST7735_HEIGHT,
		.u16OffsetX = 1,
		.u16OffsetY = 2,
};
		
//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void EmberGL_Test(void)
{
    SPI_Master_Init(&spi, 1000000, SPI_DUTYCYCLE_50_50, ST7735_SPI_TIMING | SPI_FLAG_SOFT_CS);

    ST7735_Init(&st7735);
    ST7735_FillScreen(&st7735, COLOR_RGB565_BLACK);
    ST7735_BackLight(&st7735, true);

    extern void app_entry(void* arg);
    app_entry(&st7735);
}

#endif
