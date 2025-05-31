/*
 * Copyright (c) 2022-2024 HPMicro
 *
 * SPDX-License-Identifier: BSD-3-Clause
 *
 */
/* FreeRTOS kernel includes. */
#include "FreeRTOS.h"
#include "task.h"
#include "usb_osal.h"

#include "usbh_core.h"
#include "usbh_hid.h"
#include "lv_port_disp.h"

#define task_PRIORITY (configMAX_PRIORITIES - 5U)

static USB_NOCACHE_RAM_SECTION USB_MEM_ALIGNX uint8_t hid_keyboard_buffer[64];
static USB_NOCACHE_RAM_SECTION USB_MEM_ALIGNX uint8_t hid_mouse_buffer[64];

char getAsciiCharacter(uint8_t modifier, uint8_t scanCode)
{
    char* tab;

    bool bshift = (modifier & (HID_MODIFER_LSHIFT | HID_MODIFER_RSHIFT)) ? true : false;

    switch (scanCode)
    {
        case HID_KBD_USAGE_A ... HID_KBD_USAGE_0:
        {
            scanCode -= HID_KBD_USAGE_A;

            if (bshift)
            {
                tab = "ABCDEFGHIJKLMNOPQRSTUVWXYZ!@#$%^&*())";
            }
            else
            {
                tab = "abcdefghijklmnopqrstuvwxyz1234567890";
            }

            return tab[scanCode];
        }

        case HID_KBD_USAGE_HYPHEN ... HID_KBD_USAGE_BSLASH:
        {
            scanCode -= HID_KBD_USAGE_HYPHEN;

            if (bshift)
            {
                tab = "_+{}|";
            }
            else
            {
                tab = "-=[]\\";
            }

            return tab[scanCode];
        }

        case HID_KBD_USAGE_KPD1 ... HID_KBD_USAGE_KPD0:
        {
            scanCode -= HID_KBD_USAGE_KPD1;

            tab = "1234567890";

            return tab[scanCode];
        }

        case HID_KBD_USAGE_SPACE: return ' ';
        case HID_KBD_USAGE_TAB: return '\t';

        case HID_KBD_USAGE_COLON: return bshift ? ':' : ';';
        case HID_KBD_USAGE_SQUOTE: return bshift ? '\"' : '\'';
        case HID_KBD_USAGE_LT: return bshift ? '<' : ',';
        case HID_KBD_USAGE_GT: return bshift ? '>' : '.';
        case HID_KBD_USAGE_QUESTION: return bshift ? '?' : '/';
        case HID_KBD_USAGE_KPDEXP: return '^';
        case HID_KBD_USAGE_KPDPERCENT: return '%';
        case HID_KBD_USAGE_KPDLT: return '<';
        case HID_KBD_USAGE_KPDGT: return '>';
        case HID_KBD_USAGE_KPDAMPERSAND: return '&';
        case HID_KBD_USAGE_KPDVERT: return '|';
        case HID_KBD_USAGE_KPDCOLON: return ':';
        case HID_KBD_USAGE_KPDPOUND: return '#';
        case HID_KBD_USAGE_KPDAT: return '@';
        case HID_KBD_USAGE_KPDEXCLAM: return '!';
        case HID_KBD_USAGE_KPDEQUAL: return '=';
        case HID_KBD_USAGE_GTILDE: return bshift ? '~' : '`';

#if 0
        default: printf("%X", scanCode); return 0;
#endif
        case 0x00: return 0;
    }
}

void usbh_hid_keyboard_callback(void* arg, int nbytes)
{
    struct usbh_hid* hid_class = (struct usbh_hid*)arg;

    if (nbytes > 0)
    {
        uint32_t key;

        struct usb_hid_kbd_report* keyboard = (struct usb_hid_kbd_report*)&hid_keyboard_buffer[0];

        for (int i = 0; i < 6; i++)
        {
            if ((keyboard->key[i] <= HID_KBD_USAGE_MAX) && (keyboard->key[i] > HID_KBD_USAGE_NONE))
            {
                if (keyboard->key[i] == HID_KBD_USAGE_RIGHT)
                {
                    key = LV_KEY_RIGHT;
                }
                else if (keyboard->key[i] == HID_KBD_USAGE_LEFT)
                {
                    key = LV_KEY_LEFT;
                }
                else if (keyboard->key[i] == HID_KBD_USAGE_DOWN)
                {
                    key = LV_KEY_DOWN;
                }
                else if (keyboard->key[i] == HID_KBD_USAGE_UP)
                {
                    key = LV_KEY_UP;
                }
                else if (keyboard->key[i] == HID_KBD_USAGE_ENTER || keyboard->key[i] == HID_KBD_USAGE_KPDEMTER)
                {
                    key = LV_KEY_ENTER;
                }
                else if (keyboard->key[i] == HID_KBD_USAGE_DELETE)
                {
                    key = LV_KEY_BACKSPACE;
                }
                else if (keyboard->key[i] == HID_KBD_USAGE_HOME)
                {
                    key = LV_KEY_HOME;
                }
                else if (keyboard->key[i] == HID_KBD_USAGE_END)
                {
                    key = LV_KEY_END;
                }
                else if (keyboard->key[i] == HID_KBD_USAGE_DELFWD)
                {
                    key = LV_KEY_DEL;
                }
                else
                {
                    key = getAsciiCharacter(keyboard->modifier, keyboard->key[i]);
                }

                kb_indev.last_key = key;
                kb_indev.pressed  = true;

                if (key != 0)
                {
                    printf("%c\r", key);
                }
            }

            usbh_int_urb_fill(&hid_class->intin_urb, hid_class->hport, hid_class->intin,
                              hid_keyboard_buffer, hid_class->intin->wMaxPacketSize, 0,
                              usbh_hid_keyboard_callback, hid_class);
            usbh_submit_urb(&hid_class->intin_urb);
        }
    }
}

void usbh_hid_mouse_callback(void* arg, int nbytes)
{
    struct usbh_hid* hid_class = (struct usbh_hid*)arg;

    if (nbytes > 0)
    {
        struct usb_hid_mouse_report* mouse = (struct usb_hid_mouse_report*)&hid_mouse_buffer[1];

        mouse_indev.left_button = mouse->buttons & HID_MOUSE_INPUT_BUTTON_LEFT ? 1 : 0;
        mouse_indev.x += mouse->xdisp;
        mouse_indev.y += mouse->ydisp;
        usbh_int_urb_fill(&hid_class->intin_urb, hid_class->hport, hid_class->intin, hid_mouse_buffer, hid_class->intin->wMaxPacketSize, 0, usbh_hid_mouse_callback, hid_class);
        usbh_submit_urb(&hid_class->intin_urb);

#if 0
        printf("%2d, %2d, %d\r", mouse_indev.x, mouse_indev.y, mouse_indev.left_button);
#endif
    }
    else if (nbytes == -USB_ERR_NAK)
    {
        /* only dwc2 should do this */
        usbh_int_urb_fill(&hid_class->intin_urb, hid_class->hport, hid_class->intin, hid_mouse_buffer, hid_class->intin->wMaxPacketSize, 0, usbh_hid_mouse_callback, hid_class);
        usbh_submit_urb(&hid_class->intin_urb);
    }
}

void usbh_hid_run(struct usbh_hid* hid_class)
{
    if (hid_class != NULL)
    {
        if (hid_class->hport->config.intf[hid_class->intf].altsetting[0].intf_desc.bInterfaceProtocol == HID_PROTOCOL_KEYBOARD)
        {
            usbh_int_urb_fill(&hid_class->intin_urb, hid_class->hport, hid_class->intin,
                              hid_keyboard_buffer, hid_class->intin->wMaxPacketSize, 0,
                              usbh_hid_keyboard_callback, hid_class);
            usbh_submit_urb(&hid_class->intin_urb);
            USB_LOG_RAW("mount a keyboard\r\n");
        }
        else if (hid_class->hport->config.intf[hid_class->intf].altsetting[0].intf_desc.bInterfaceProtocol == HID_PROTOCOL_MOUSE)
        {
            usbh_int_urb_fill(&hid_class->intin_urb, hid_class->hport, hid_class->intin,
                              hid_mouse_buffer, hid_class->intin->wMaxPacketSize, 0,
                              usbh_hid_mouse_callback, hid_class);
            usbh_submit_urb(&hid_class->intin_urb);
            USB_LOG_RAW("mount a mouse\r\n");
        }
        else
        {
        }
    }
}

void usbh_hid_stop(struct usbh_hid* hid_class)
{
    if (hid_class != NULL)
    {
        if (hid_class->hport->config.intf[hid_class->intf].altsetting[0].intf_desc.bInterfaceProtocol == HID_PROTOCOL_KEYBOARD)
        {
        }
        else if (hid_class->hport->config.intf[hid_class->intf].altsetting[0].intf_desc.bInterfaceProtocol == HID_PROTOCOL_MOUSE)
        {
        }
        else
        {
        }
    }
}
