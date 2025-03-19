#include "kiss_fft.h"

#if defined(USE_HAL_DRIVER) && defined(STM32F407xx)
// #include "rng.h"
#include "stm32f4xx_hal.h"
extern RNG_HandleTypeDef hrng;
#define rand() HAL_RNG_GetRandomNumber(&hrng)
#endif

static kiss_fft_scalar rand_scalar(void)
{
    kiss_fft_scalar s = (kiss_fft_scalar)((rand() + 10) % 256);
    return s / 256.;
}

static void print_fft_result(kiss_fft_cpx* x, int n)
{
    int l = 0;
    for (int i = 0; i < n; i++)
    {
        printf("(%4.4f+%4.4fi), ", x[i].r, x[i].i);
        if (l++ == 7)
        {
            l = 0;
            printf("\n");
        }
    }
    printf("\n");
}

void KissFFT_Test()  // 只测试基本用法
{
    int          i    = 0;
    int          nfft = 20;
    kiss_fft_cpx cin[nfft];
    kiss_fft_cpx cout[nfft];
    kiss_fft_cpx sout[nfft];
    kiss_fft_cfg kiss_fft_state;

    kiss_fft_scalar zero;
    memset(&zero, 0, sizeof(zero));

    for (i = 0; i < nfft; ++i)
    {
        cin[i].r = rand_scalar();
        cin[i].i = zero;
    }
    printf("\n");

    printf(" init data for kiss_fft (cin): \n");
    print_fft_result(cin, nfft);

    memset(cout, 0, sizeof(short) * nfft);
    memset(sout, 0, sizeof(short) * nfft);

    kiss_fft_state = kiss_fft_alloc(nfft, 0, 0, 0);

    kiss_fft(kiss_fft_state, cin, cout);
    kiss_fft_free(kiss_fft_state);

    printf(" results from kiss_fft (cout): \n");
    print_fft_result(cout, nfft);

    kiss_fft_state = kiss_fft_alloc(nfft, 1, 0, 0);

    for (i = 0; i < nfft; i++)
    {
        cout[i].r /= nfft;
        cout[i].i /= nfft;
    }
    // case A.
    kiss_fft(kiss_fft_state, cout, sout);

    // end case
    kiss_fft_free(kiss_fft_state);

    printf(" results from kiss_ifft (sout): \n");
    print_fft_result(sout, nfft);
    printf("\n");
}
