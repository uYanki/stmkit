#if CONFIG_DEMOS_SW || 1

#include "egl_device_lib.h"
#include "egl_texture.h"

EGL_USING_NAMESPACE

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "egl_demo"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

typedef graphics_device_st7735                                    gfx_device_t;
typedef sampler2d<pixfmt_r5g6b5, texfilter_linear, texaddr_wrap>  smp_r5g6b5_linear_wrap_t;
typedef sampler2d<pixfmt_r5g6b5, texfilter_linear, texaddr_clamp> smp_r5g6b5_linear_clamp_t;

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

static gfx_device_t s_gfx_device;

static const EGL_ALIGN(4) uint32_t s_ptx_smiley_data[] = {
#include "ptx_smiley.h"
};

static texture s_tex_smiley;

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

template <class Sampler>
struct test_shader {
    // construction
    test_shader(const texture* tex_, int16_t x_, int16_t y_, float scale_x_, float scale_y_, const color_rgbaf& tint_)
        : tex(tex_), x(x_), y(y_), scale_x(scale_x_), scale_y(scale_y_), tint(tint_) {}

    // pixel shading
    template <e_pixel_format dst_fmt>
    EGL_INLINE void exec(pixel<dst_fmt>& res_, uint16_t x_, uint16_t y_) const
    {
        // 缩放
        float       u = (x_ - x) * scale_x;
        float       v = (y_ - y) * scale_y;
        color_rgbaf col;
        sampler.sample(col, *tex, vec2f(u, v));
        res_ = col * tint;
    }

    const texture* tex;
    int16_t        x, y;
    float          scale_x, scale_y;
    color_rgbaf    tint;
    Sampler        sampler;
};

extern "C" void app_entry(void* arg)
{
    s_gfx_device.init(arg);

    s_tex_smiley.init(s_ptx_smiley_data);

    int16_t x, y, w, h;

    uint8_t i = 0;
    while (1)
    {
        switch (i)
        {
            case 0:  // 缩小（原图64x64）
            {
                x = 0, y = 0, w = 50, h = 50;
                test_shader<smp_r5g6b5_linear_clamp_t> sh(&s_tex_smiley, x, y, 1.0f / w, 1.0f / h, color_rgbaf(1.0f, 1.0f, 1.0f, 1.0f));
                s_gfx_device.draw_rect(x, y, w, h, sh);
                break;
            }
            case 1:  // 放大
            {
                x = 0, y = 0, w = 80, h = 80;
                test_shader<smp_r5g6b5_linear_clamp_t> sh(&s_tex_smiley, x, y, 1.0f / w, 1.0f / h, color_rgbaf(1.0f, 1.0f, 1.0f, 1.0f));
                s_gfx_device.draw_rect(x, y, w, h, sh);
                break;
            }
            case 2:  // 垂直翻转，纹理染红色
            {
                x = 0, y = 0, w = 64, h = 64;
                test_shader<smp_r5g6b5_linear_clamp_t> sh(&s_tex_smiley, x, y + 64, 1.0f / w, -1.0f / h, color_rgbaf(1.0f, 0.5f, 0.5f, 0.5f));
                s_gfx_device.draw_rect(x, y, w, h, sh);
                break;
            }
            case 3:  // 平铺，水平和垂直两次

            {
                x = 0, y = 0, w = 64, h = 64;
                test_shader<smp_r5g6b5_linear_wrap_t> sh(&s_tex_smiley, x, y, 2.0f / w, 2.0f / h, color_rgbaf(1.0f, 1.0f, 1.0f, 1.0f));
                s_gfx_device.draw_rect(x, y, w, h, sh);
                break;
            }
            case 4:  // 挤压（非均匀缩放）
            {
                x = 0, y = 0, w = 100, h = 50;
                test_shader<smp_r5g6b5_linear_clamp_t> sh(&s_tex_smiley, x, y, 1.0f / w, 1.0f / h, color_rgbaf(1.0f, 1.0f, 1.0f, 1.0f));
                s_gfx_device.draw_rect(x, y, w, h, sh);
                break;
            }
        }

        if (++i == 5)
        {
            i = 0;
        }

        DelayBlockMs(2000);
    }
}

#endif
