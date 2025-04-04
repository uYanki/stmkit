#ifndef CCONTROL_INC_H_
#define CCONTROL_INC_H_

/* C89 standard library */
#include <string.h> /* For memcpy, memset etc */
#include <stdio.h>  /* For printf */
#include <stdlib.h> /* Standard library */
#include <math.h>   /* For sqrtf */
#include <float.h>  /* Required for FLT_EPSILON, FLT_MAX, FLT_MIN */
#include <stddef.h> /* Requried for NULL */
#include <time.h>   /* For srand, clock */

/* Libraries for Visual Studio */
#ifdef _MSC_VER
#include <crtdbg.h>
#include <intrin.h>
#endif /* !_MSC_VER */

/*
 * defines.h
 */

#ifndef __cplusplus

/* In ANSI C (C89), the __STDC_VERSION__ is not defined */
#ifndef __STDC_VERSION__
#define __STDC_VERSION__ 199409L /* STDC version of C89 standard */
#endif

#if __STDC_VERSION__ < 199901L
typedef unsigned char      uint8_t;
typedef unsigned short     uint16_t;
typedef unsigned int       uint32_t;
typedef unsigned long long uint64_t;
typedef signed char        int8_t;
typedef signed short       int16_t;
typedef signed int         int32_t;
typedef uint8_t bool;
#define true  1
#define false 0
#define IS_C89
#ifndef _MSC_VER
#define NULL ((void*)0)
typedef unsigned long long size_t;
#endif /* !_MSC_VER */
#else
#include <stdbool.h> /* For bool datatype */
#include <stdint.h>  /* For uint8_t, uint16_t and uint32_t etc. */
#endif               /* !__STDC_VERSION__ */
#endif               /* !__cplusplus */

/* For memory leaks in Visual Studio */
#ifdef _MSC_VER
#define _CRTDBG_MAP_ALLOC
#endif /* !_MSC_VER */

/* If ARM compiler is used */
#if defined(__aarch64__) || defined(__arm__)
#define ARM_IS_USED
#endif /* !!defined(__aarch64__) || !defined(__arm__) */

/* Define for all */
#define PI                          3.14159265358979323846f /* Constant PI */
#define MIN_VALUE                   1e-11f                  /* Tuning parameter for the smalles value that can be allowed */
#define MAX_ITERATIONS              10000U                  /* For all iteration algorithm */
#define CONV_MAX_KERNEL_FFT_INSTEAD 80                      /* When we are going to use FFT with conv or conv2 */

/* Select library by uncomment - If non of these are uncomment, then CControl will use the internal library instead */
#ifndef ARM_IS_USED
#define MKL_LAPACK_USED /* For large matrices on a regular computer */
#define MKL_FFT_USED    /* For large matrices on a regular computer */
#else
#define CLAPACK_USED /* For larger embedded systems */
#endif               /* !ARM_IS_USED */

/*
 * enums.h
 */

/* For lqi.c */
typedef enum {
    ANTI_WINUP_ALWAYS_INTEGRATE,
    ANTI_WINUP_ONLY_INTEGRATE_WHEN_R_GRATER_THAN_Y_ELSE_DELETE,
    ANTI_WINUP_ONLY_INTEGRATE_WHEN_R_Y
} ANTI_WINUP;

/* For norm.c */
typedef enum {
    NORM_METHOD_L1,
    NORM_METHOD_L2,
    NORM_METHOD_FROBENIUS
} NORM_METHOD;

/* For sort.c */
typedef enum {
    SORT_MODE_ROW_DIRECTION_ASCEND,
    SORT_MODE_ROW_DIRECTION_DESCEND,
    SORT_MODE_COLUMN_DIRECTION_ASCEND,
    SORT_MODE_COLUMN_DIRECTION_DESCEND,
} SORT_MODE;

/* For Astar.c */
typedef enum {
    ASTAR_MODE_L1,
    ASTAR_MODE_L2
} ASTAR_MODE;

/* For pdist2.c */
typedef enum {
    PDIST2_METRIC_SQEUCLIDEAN,
    PDIST2_METRIC_EUCLIDEAN,
} PDIST2_METRIC;

/* For find.c */
typedef enum {
    FIND_CONDITION_METOD_E,  /* = */
    FIND_CONDITION_METOD_GE, /* >= */
    FIND_CONDITION_METOD_G,  /* > */
    FIND_CONDITION_METOD_LE, /* <= */
    FIND_CONDITION_METOD_L   /* < */
} FIND_CONDITION_METOD;

/* For pooling.c */
typedef enum {
    POOLING_METHOD_NO_POOLING,
    POOLING_METHOD_MAX,
    POOLING_METHOD_AVERAGE,
    POOLING_METHOD_SHAPE
} POOLING_METHOD;

/* For kernel.c */
typedef enum {
    KERNEL_METHOD_LINEAR,
    KERNEL_METHOD_RBF,
    KERNEL_METHOD_POLY,
    KERNEL_METHOD_SIGMOID,
    KERNEL_METHOD_GAUSSIAN,
    KERNEL_METHOD_EXPONENTIAL
} KERNEL_METHOD;

/* For lbp.c */
typedef enum {
    LBP_BIT_8,
    LBP_BIT_16,
    LBP_BIT_24,
    LBP_BIT_32
} LBP_BIT;

/* For featuredetection.c */
typedef enum {
    FAST_METHOD_9,
    FAST_METHOD_10,
    FAST_METHOD_11,
    FAST_METHOD_12
} FAST_METHOD;

/* For area.c */
typedef enum {
    AREA_METHOD_CIRCLE,
    AREA_METHOD_SQURE
} AREA_METHOD;

/* For nn.c */
typedef enum {
    ACTIVATION_FUNCTION_HIGHEST_VALUE_INDEX,
    ACTIVATION_FUNCTION_CLOSEST_VALUE_INDEX
} ACTIVATION_FUNCTION;

/* For imcollect.c */
typedef enum {
    MODEL_CHOICE_FISHERFACES
} MODEL_CHOICE;

/* For sobel.c */
typedef enum {
    SOBEL_METHOD_GRADIENT,
    SOBEL_METHOD_ORIENTATION,
    SOBEL_METHOD_GRADIENT_ORIENTATION,
    SOBEL_METHOD_GRADIENT_X_Y
} SOBEL_METHOD;

/* For conv.c and conv2.c */
typedef enum {
    CONV_SHAPE_FULL,
    CONV_SHAPE_SAME,
    CONV_SHAPE_SAME_NO_FFT,
    CONV_SHAPE_SAME_SEPARABLE_KERNEL,
    CONV_SHAPE_VALID
} CONV_SHAPE;

/* For fspecial.c */
typedef enum {
    FSPECIAL_TYPE_GAUSSIAN_2D,
    FSPECIAL_TYPE_GAUSSIAN_1D,
    FSPEICAL_TYPE_SOBEL_X,
    FSPEICAL_TYPE_SOBEL_Y,
    FSPECIAL_TYPE_BOX_OF_ONES
} FSPECIAL_TYPE;

/* For hog.c */
typedef enum {
    HOG_BINS_9,
    HOG_BINS_10,
    HOG_BINS_12,
    HOG_BINS_15,
    HOG_BINS_18,
    HOG_BINS_20
} HOG_BINS;

/* For normalize.c */
typedef enum {
    NORMALIZE_METHOD_UNIT_CIRCLE,
    NORMALIZE_METHOD_TOTAL_SUM_1
} NORMALIZE_METHOD;

/* For haarlike.c */
typedef enum {
    HAARLIKE_FEATURE_CHOICE_EDGE_VERTICAL,
    HAARLIKE_FEATURE_CHOICE_EDGE_HORIZONTAL,
    HAARLIKE_FEATURE_CHOICE_LINE_VERTICAL,
    HAARLIKE_FEATURE_CHOICE_LINE_HORIZONTAL,
    HAARLIKE_FEATURE_CHOICE_CENTER,
    HAARLIKE_FEATURE_CHOICE_SQUARES,
    HAARLIKE_FEATURE_CHOICE_CROSS,
    HAARLIKE_FEATURE_CHOICE_UP_U,
    HAARLIKE_FEATURE_CHOICE_DOWN_U,
    HAARLIKE_FEATURE_CHOICE_X,
    HAARLIKE_FEATURE_CHOICE_UP_T,
    HAARLIKE_FEATURE_CHOICE_DOWN_T,
    HAARLIKE_FEATURE_CHOICE_TILTED_LEFT_T,
    HAARLIKE_FEATURE_CHOICE_TILTED_RIGHT_T,
    HAARLIKE_FEATURE_CHOICE_UP_L,
    HAARLIKE_FEATURE_CHOICE_DOWN_L,
    HAARLIKE_FEATURE_CHOICE_UP_MIRROR_L,
    HAARLIKE_FEATURE_CHOICE_DOWN_MIRROR_L,
    HAARLIKE_FEATURE_CHOICE_H,
    HAARLIKE_FEATURE_CHOICE_TILTED_H,
    HAARLIKE_FEATURE_CHOICE_UP_Y,
    HAARLIKE_FEATURE_CHOICE_DOWN_Y,
    HAARLIKE_FEATURE_CHOICE_TILTED_RIGHT_Y,
    HAARLIKE_FEATURE_CHOICE_TILTED_LEFT_Y,
    HAARLIKE_FEATURE_TOTAL_HAARLIKES
} HAARLIKE_FEATURE_CHOICE;

/*
 * macros.h
 */

/* Compute array size */
#ifndef ARRAY_SIZE
#define ARRAY_SIZE(X) sizeof(X) / sizeof(sizeof(X[0])) /* Length mesaurement for non-pointer array */
#endif                                                 // !ARRAY_SIZE

/* Swap macro */
#define SWAP(x, y, T)  \
    do {               \
        T SWAP = x;    \
        x      = y;    \
        y      = SWAP; \
    } while (0)

/* Declare inline */
#ifndef IS_C89
#define INLINE inline
#else
#define INLINE
#endif /* !IS_C89 */

/*
 * structs.h
 */

/* For imshow.c and imread.c */
typedef struct {
    size_t   width;
    size_t   height;
    uint8_t  max_gray_value;
    uint8_t* pixels;
} PGM;

typedef struct {
    /* Model */
    uint8_t             total_models;
    float*              model_w[10];
    float*              model_b[10];
    size_t              model_row[10];
    size_t              model_column[10];
    ACTIVATION_FUNCTION activation_function[10];

    /* Data */
    size_t   input_row;
    size_t   input_column;
    float*   input;
    uint8_t* class_id;
    uint8_t  classes;
} MODEL_NN;

/* Model holder */
typedef struct {
    MODEL_NN     fisherfaces_model;
    MODEL_CHOICE model_choice;
} MODEL;

/* For NN models */
typedef struct {
    /* General */
    char folder_path[260];
    bool save_model;

    /* For nn.c */
    float C;
    float lambda;

    /* For kpda_lda_nn.c */
    bool    remove_outliers;
    float   epsilon;
    uint8_t min_pts;

    /* For kpda_lda_nn.c */
    size_t        components_pca;
    float         kernel_parameters[2];
    KERNEL_METHOD kernel_method;

    /* For pooing.c */
    uint8_t        pooling_size;
    POOLING_METHOD pooling_method;
} MODEL_NN_SETTINGS;

/* For imcollect.c */
typedef struct {
    MODEL_NN_SETTINGS settings_fisherfaces;
    MODEL_CHOICE      model_choice;
} MODEL_SETTINGS;

/* For featuredetection.c */
typedef struct {
    int x;
    int y;
} COORDINATE_XY;

/* For generalizedhough.c */
typedef struct {
    float alpha;
    float R;
    float shortest;
} GENERALIZED_HOUGH_VOTE;

/* For generalizedhough.c */
typedef struct {
    GENERALIZED_HOUGH_VOTE* vote;
    size_t                  votes_active;
} GENERALIZED_HOUGH_MODEL;

/* For adaboost.c */
typedef struct {
    float  polarity;
    size_t feature_index;
    float  threshold;
    float  alpha;
} ADABOOST_MODEL;

/* For haarlike.c */
typedef struct {
    HAARLIKE_FEATURE_CHOICE haarlike_feature_choice;
    uint8_t                 x1, x2, x3, x4, y1, y2, y3, y4;
    int8_t                  value;
} HAARLIKE_FEATURE;

/* For violajones.c */
typedef struct {
    HAARLIKE_FEATURE haarlike_feature;
    ADABOOST_MODEL   adaboost_model;
} VIOLAJONES_MODEL;

/*
 * unions.h
 */

/* Covert float to uint8_t array */
typedef union {
    float   value;
    uint8_t array[4];
} FLOAT_UINT8;

/*
 * functions.h
 */

#ifdef __cplusplus
extern "C" {
#endif

#if __STDC_VERSION__ < 199901L
#if !defined(_MSC_VER) && !defined(ARM_IS_USED)
INLINE float sqrtf(float x)
{
    return (float)sqrt(x);
}

INLINE float fabsf(float x)
{
    return (float)fabs(x);
}

INLINE float acosf(float x)
{
    return (float)acos(x);
}

INLINE float atan2f(float x)
{
    return (float)atan(x);
}

INLINE float expf(float x)
{
    return (float)exp(x);
}

INLINE float powf(float base, float power)
{
    return (float)pow(base, power);
}

INLINE float logf(float x)
{
    return (float)log(x);
}

INLINE float sinf(float x)
{
    return (float)sin(x);
}

INLINE float tanhf(float x)
{
    return (float)tanh(x);
}

float roundf(float x)
{
    return (float)round(x);
}

INLINE float ceilf(float x)
{
    return (float)ceil(x);
}

INLINE float floorf(float x)
{
    return (float)floor(x);
}

INLINE float fmodf(float x, float y)
{
    return (float)fmod(x, y);
}

#endif /* !defined(_MSC_VER) && !defined(ARM_IS_USED) */
#endif /* !__STDC_VERSION__ */
#ifdef __cplusplus
}
#endif

/* Load the MKL library */
#if defined(MKL_LAPACK_USED) || defined(MKL_FFT_USED)
#include <mkl.h>
#endif

#endif
