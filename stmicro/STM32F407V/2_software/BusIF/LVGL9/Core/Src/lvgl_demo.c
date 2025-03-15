

#include "typebasic.h"

#if CONFIG_DEMOS_SW || 1

#include "lvgl.h"
#include "porting/lv_port_indev.h"
#include "porting/lv_port_disp.h"

#define CONFIG_TARGET_DEMO DEMO_KEY_INPUT

#if CONFIG_TARGET_DEMO == DEMO_BENCHMARK
#include "demos/benchmark/lv_demo_benchmark.h"
#endif

//---------------------------------------------------------------------------
// Definitions
//---------------------------------------------------------------------------

#define LOG_LOCAL_TAG   "lvgl-demo"
#define LOG_LOCAL_LEVEL LOG_LEVEL_INFO

/**
 * @brief CONFIG_TARGET_DEMO
 */
#define DEMO_KEY_INPUT 0
#define DEMO_BENCHMARK 1

//---------------------------------------------------------------------------
// Prototypes
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Variables
//---------------------------------------------------------------------------

//---------------------------------------------------------------------------
// Functions
//---------------------------------------------------------------------------

#if CONFIG_TARGET_DEMO == DEMO_KEY_INPUT

static void btn_event_cb(lv_event_t* event)
{
    lv_obj_t* btn = lv_event_get_target(event);
    if (event->code == LV_EVENT_CLICKED)
    {
        static uint8_t cnt   = 0;
        /*Get the first child of the button which is the label and change its text*/
        lv_obj_t*      label = lv_obj_get_child(btn, NULL);
        lv_label_set_text_fmt(label, "Button: %d", ++cnt);
    }
}

static void lvgl_first_demo_start(void)
{
    lv_obj_t* btn = lv_btn_create(lv_scr_act());                                   /*Add a button the current screen*/
    lv_obj_set_pos(btn, 10, 10);                                                   /*Set its position*/
    lv_obj_set_size(btn, 100, 30);                                                 /*Set its size*/
    lv_obj_add_event_cb(btn, (lv_event_cb_t)btn_event_cb, LV_EVENT_CLICKED, NULL); /*Assign a callback to the button*/

    lv_obj_t* label = lv_label_create(btn); /*Add a label to the button*/
    lv_label_set_text(label, "Yeah");       /*Set the labels text*/

    lv_obj_t* label1 = lv_label_create(lv_scr_act());
    lv_label_set_text(label1, "Hello world!");
    lv_obj_align(label1, LV_ALIGN_CENTER, 0, 0);
    lv_obj_align_to(btn, label1, LV_ALIGN_OUT_TOP_MID, 0, -10);
}

#endif

void LVGL_Test()
{
    lv_init();
    lv_port_disp_init();
    lv_port_indev_init();

#if CONFIG_TARGET_DEMO == DEMO_KEY_INPUT
    lvgl_first_demo_start();
#elif CONFIG_TARGET_DEMO == DEMO_BENCHMARK
    lv_demo_benchmark();
#endif
    while (1)
    {
        lv_task_handler();
    }
}

#endif
