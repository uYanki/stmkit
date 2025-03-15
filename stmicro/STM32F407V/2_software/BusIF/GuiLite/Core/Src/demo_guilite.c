#include "spi_st7735.h"

#if CONFIG_DEMOS_SW

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "guilite"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

#define rgb_32to16(rgb) ((rgb & 0xFF) >> 3) | ((rgb & 0xFC00) >> 5) | ((rgb & 0xF80000) >> 8)

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

#ifndef __cplusplus
struct DISPLAY_DRIVER {
    void (*draw_pixel)(int x, int y, uint32_t rgb);
    void (*fill_rect)(int x0, int y0, int x1, int y1, uint32_t rgb);
} driver;
#else
struct DISPLAY_DRIVER driver;
#endif

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

void delay_ms(unsigned short nms)
{
    DelayBlockMs(nms);
}

static void gfx_draw_pixel(int x, int y, uint32_t rgb)
{
    ST7735_DrawPixel(&st7735, x, y, rgb_32to16(rgb));
}

static void gfx_fill_rect(int x0, int y0, int x1, int y1, uint32_t rgb)
{
    if (x1 <= x0 || y1 <= y0)
    {
        return;
    }

    ST7735_FillRect(&st7735, x0, y0, x1 - x0 + 1, y1 - y0 + 1, rgb_32to16(rgb));
}

void GuiLite_Test(void)
{
    SPI_Master_Init(&spi, 1000000, SPI_DUTYCYCLE_50_50, ST7735_SPI_TIMING | SPI_FLAG_SOFT_CS);

    ST7735_Init(&st7735);
    ST7735_BackLight(&st7735, true);

    driver.draw_pixel = gfx_draw_pixel;
    driver.fill_rect  = gfx_fill_rect;

    GuiLiteDemo(NULL, ST7735_WIDTH, ST7735_HEIGHT, 2, &driver);
}

#endif
