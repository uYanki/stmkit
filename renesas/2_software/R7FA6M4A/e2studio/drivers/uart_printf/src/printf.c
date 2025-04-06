#include "hal_data.h"
#include <stdio.h>

 #include <sys/stat.h>
 #include <unistd.h>
 #include <errno.h>

#ifdef __GNUC__
#define PUTCHAR_PROTOTYPE int __io_putchar(int ch)
#else
#define PUTCHAR_PROTOTYPE int fputc(int ch, FILE* f)
#endif



//  Prevent compilation warnings
PUTCHAR_PROTOTYPE;
int _write(int fd, char* pBuffer, int size);
int _read(int fd, char *pBuffer, int size);
int _isatty(int fd);
int _close(int fd);
int _lseek(int fd, int ptr, int dir);
int _fstat(int fd, struct stat *st);


PUTCHAR_PROTOTYPE
{
    fsp_err_t err = R_SCI_UART_Write(&g_dbguart_ctrl, (uint8_t*)&ch, 1);

    if (FSP_SUCCESS != err)
    {
        __BKPT();
    }

    // Transmit Data Empty Flag
    while (! g_dbguart_ctrl.p_reg->SSR_b.TEND) {}

    return ch;
}

int _write(int fd, char* pBuffer, int size)
{
    (void) fd;

    for (int i = 0; i < size; i++)
    {
        __io_putchar(*pBuffer++);
    }

    return size;
}

int _read(int fd, char *pBuffer, int size) // 丢数据
{
    (void) fd;
    (void) pBuffer;
    (void) size;

    return -1;
}

__attribute__((weak)) int _isatty(int fd)
{
    if (fd >= STDIN_FILENO && fd <= STDERR_FILENO)
        return 1;

    errno = EBADF;
    return 0;
}

__attribute__((weak)) int _close(int fd)
{
    if (fd >= STDIN_FILENO && fd <= STDERR_FILENO)
        return 0;

    errno = EBADF;
    return -1;
}

__attribute__((weak)) int _lseek(int fd, int ptr, int dir)
{
    (void) fd;
    (void) ptr;
    (void) dir;

    errno = EBADF;
    return -1;
}

__attribute__((weak)) int _fstat(int fd, struct stat *st)
{
    if (fd >= STDIN_FILENO && fd <= STDERR_FILENO)
    {
        st->st_mode = S_IFCHR;
        return 0;
    }

    errno = EBADF;
    return 0;
}
