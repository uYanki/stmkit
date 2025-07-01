#include "queue.h"

/**
 * @brief  queue_init
 * @param  Front , Rear , PBase , Len
 * @retval true
 */
bool queue_init(uint16_t* Front, uint16_t* Rear, uint8_t* PBase, uint16_t Len)
{
    uint16_t index;

    for (index = 0; index < Len; index++)
    {
        PBase[index] = 0;
    }

    *Front = *Rear = 0;
    return true;
}

/**
 * @brief  queue_full
 * @param  Front , Rear , PBase , Len
 * @retval Result of Queue Operation as Enum
 */
bool queue_full(uint16_t* Front, uint16_t* Rear, uint8_t* PBase, uint16_t Len)
{
    if ((((*Rear) + 1) % Len) == *Front)
    {
        return true;
    }
    else
    {
        return false;
    }
}

/**
 * @brief  queue_empty
 * @param  Front , Rear , PBase , Len
 * @retval Result of Queue Operation as Enum
 */
bool queue_empty(uint16_t* Front, uint16_t* Rear, uint8_t* PBase, uint16_t Len)
{
    if (*Front == *Rear)
    {
        return true;
    }
    else
    {
        return false;
    }
}

/**
 * @brief  queue_in
 * @param  Front , Rear , PBase , Len
 * @retval Result of Queue Operation as Enum
 */
bool queue_in(uint16_t* Front, uint16_t* Rear, uint8_t* PBase, uint16_t Len, uint8_t* PData)
{
    // DISABLE_ALL_IRQ();

    if (queue_full(Front, Rear, PBase, Len))
    {
        return false;
    }

    PBase[*Rear] = *PData;
    *Rear        = ((*Rear) + 1) % Len;

    // ENABLE_ALL_IRQ();

    return true;
}

/**
 * @brief  queue_out
 * @param  Front , Rear , PBase , Len
 * @retval Result of Queue Operation as Enum
 */

bool queue_out(uint16_t* Front, uint16_t* Rear, uint8_t* PBase, uint16_t Len, uint8_t* PData)
{
    // DISABLE_ALL_IRQ();

    if (queue_empty(Front, Rear, PBase, Len))
    {
        return false;
    }

    *PData = PBase[*Front];
    *Front = ((*Front) + 1) % Len;

    // ENABLE_ALL_IRQ();

    return true;
}
