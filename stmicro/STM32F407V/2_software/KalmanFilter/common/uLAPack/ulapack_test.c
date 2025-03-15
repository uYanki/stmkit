/**
 * @file main.c
 * @brief Main test driving code for uLAPack.
 *
 * @author Sargis Yonan
 * @date July 8, 2017
 *
 * @version 1.0.1
 **/

#include "ulapack.h"
#include <stdbool.h>
#include <math.h>

#define UT_PI 3.14159265358979323846264338327

#define println(fmt, ...) printf(fmt "\n", ##__VA_ARGS__)

/*
 * Total unit test error counter.
 */
static uint64_t ut_error_counter = 0;

/**
 * @name ut_iserror
 * @brief Prints an error message if an error code is given as an argument.
 *
 * @note The total error counter is incremented upon passed in error.
 *
 * @param err The error code
 *
 * @return true if an error code was passed in. False if not an error code.
 *
 * @todo Print the actual error message describing the actual error if one.
 *       Haven't had the use for this yet, but the function is piped in for
 *       that purpose.
 */
static bool ut_iserror(MatrixError_t err) {
    if (err != ulapack_success) {
        println("Unit test error: return code %d", (int)err);
        ut_error_counter++;
        return true;
    }

    return false;
}

#define INFO(msg) \
    fprintf(stderr, "%s:%d: ", __FILE__, __LINE__); \
    fprintf(stderr, "%s\n", msg)

#define ut_incr_error_if(condition, msg) do { \
                                    if (condition) { \
                                        INFO(msg); \
                                        ut_error_counter++; \
                                        break; \
                                    } else { \
                                        break; \
                                    } } while(1)

#define ut_incr_error_ifnot(condition, msg) do { \
                                    if (! (condition) ) { \
                                        INFO(msg); \
                                        ut_error_counter++; \
                                        break; \
                                    } else { \
                                        break; \
                                    } } while(1)

static MatrixError_t test_initialization(void) {
    MatrixError_t ret_code;

    #ifdef ULAPACK_USE_STATIC_ALLOC
        Matrix_t A;
        Matrix_t B;
        Matrix_t C;

        /*
         * Test under the maximum, and check for success.
         */
        ret_code = ulapack_init(&A, 3u, 3u);
        if (ut_iserror(ret_code)) {
            println("Cannot initialize matrix A.");
            return ret_code;
        }
        if (A.n_rows != 3 || A.n_cols != 3) {
            println("Matrix A dimensions do not match expected values.");
            return ulapack_error;
        }

        ret_code = ulapack_init(&B, 
            ULAPACK_MAX_MATRIX_N_ROWS, 
            ULAPACK_MAX_MATRIX_N_COLS);

        if (ut_iserror(ret_code)) {
            println("Cannot initialize matrix B.");
            return ret_code;
        }
        if (B.n_rows != ULAPACK_MAX_MATRIX_N_ROWS || 
            B.n_cols != ULAPACK_MAX_MATRIX_N_COLS) {
            println("Matrix B dimensions do not match expected values.");
            return ulapack_error;
        }

        /*
         * Try to allocate more than allowed and check for failure.
         */
        ret_code = ulapack_init(&C, 
            ULAPACK_MAX_MATRIX_N_ROWS + 1, 
            ULAPACK_MAX_MATRIX_N_COLS + 1);

        ut_incr_error_ifnot(ret_code == ulapack_invalid_argument, 
            "Matrix C allocated when exceeding expected limits."
                "Error in initialization function.");

        /*
         * The rows and cols should be zero.
         */
        if (C.n_rows != 0 || C.n_cols != 0) {
            println("Matrix C dimensions does not match expected values of 0.");
            return ulapack_error;
        }

        /*
         * Try to give init NULL.
         */
        ret_code = ulapack_init(NULL, 
            1, 
            1);

        ut_incr_error_ifnot(ret_code == ulapack_invalid_argument, 
            "NULL allocated. Error in initialization function.");

    #endif

    #ifdef ULAPACK_USE_DYNAMIC_ALLOC
        Matrix_t *A = NULL;
        /*
         * Test dynamic initialization.
         */
        ret_code = ulapack_init(&A, 3u, 3u);
        if (ut_iserror(ret_code)) {
            println("Cannot initialize matrix A.");
            return ret_code;
        }
        if (A->n_rows != 3 || A->n_cols != 3) {
            println("Matrix A dimensions do not match expected values.");
            return ulapack_error;
        }

        /*
         * Try reinitializing the matrix. It should fail.
         */
        ret_code = ulapack_init(&A, 3u, 3u);
        ut_incr_error_ifnot(ret_code == ulapack_invalid_argument, 
            "Error: Reinitialize matrix A.");

        if (A->n_rows != 3 || A->n_cols != 3) {
            println("Matrix A reinitialized and lost row and col count.");
            return ulapack_error;
        }

        ulapack_destroy(A);

    #endif

    return ulapack_success;
}

static MatrixError_t test_basic_operations(void) {

    Matrix_t *A = NULL;
    Matrix_t *B = NULL;
    Matrix_t *result = NULL;
    Matrix_t *result2 = NULL;
    Matrix_t *expected = NULL;

    MatrixEntry_t entry_value = 0;

    MatrixError_t ret_value;

    #ifdef ULAPACK_USE_STATIC_ALLOC
        Matrix_t Amem;
        Matrix_t Bmem;
        Matrix_t Resultmem;
        Matrix_t Result2mem;
        Matrix_t Expectedmem;

        A = &Amem;
        B = &Bmem;
        result = &Resultmem;
        result2 = &Result2mem;
        expected = &Expectedmem;

        ut_iserror(ulapack_init(A, 3u, 3u));
        ut_iserror(ulapack_init(B, 3u, 3u));

        ut_iserror(ulapack_init(result, 3u, 3u));
        ut_iserror(ulapack_init(result2, 3u, 3u));
        ut_iserror(ulapack_init(expected, 3u, 3u));
    #endif

    #ifdef ULAPACK_USE_DYNAMIC_ALLOC
        ut_iserror(ulapack_init(&A, 3u, 3u));
        ut_iserror(ulapack_init(&B, 3u, 3u));

        ut_iserror(ulapack_init(&result, 3u, 3u));
        ut_iserror(ulapack_init(&result2, 3u, 3u));
        ut_iserror(ulapack_init(&expected, 3u, 3u));
    #endif

    /*
     * First test the happy path.
     */

    /*
     * Set A=3 * I_{3x3}.
     */
    ulapack_eye(A);
    ulapack_scale(A, 3, A);

    println("\nMatrix A =");
    ulapack_print(A, stdout);

    ulapack_sum(A, &entry_value);
    ut_incr_error_ifnot(entry_value == 3+3+3,
        "Expected sum result doesn't equal actual.");
    println("sum(A) = " ULAPACK_PRINT_DELIMITER "", entry_value);


    ulapack_norm(A, &entry_value);
    ut_incr_error_ifnot(entry_value == sqrt(3*3 + 3*3 + 3*3), // sqrt? sqrtf?
        "Expected norm result doesn't equal actual.");
    println("norm(A) = " ULAPACK_PRINT_DELIMITER "", entry_value);

    ut_iserror(ulapack_det(A, &entry_value));
    ut_incr_error_ifnot(entry_value == 27,
        "Expected determinant result doesn't equal actual.");
    println("det(A) = " ULAPACK_PRINT_DELIMITER "", entry_value);

    ut_iserror(ulapack_inverse(A, result));
    println("\ninv(A) =");
    ulapack_print(result, stdout);

    ut_iserror(ulapack_pinverse(A, result2));
    println("\npinv(A) =");
    ulapack_print(result2, stdout);

    /*
     * Expected: pinv == inv for this matrix.
     */
    ulapack_is_equal(result, result2, &ret_value);
    ut_incr_error_ifnot(ret_value == ulapack_success, "Error in pinv or inv.");

    /*
     * Set B equal to a matrix of all pi.
     */
    ulapack_set(B, UT_PI);
    ut_iserror(ulapack_add(A, B, result));

    ulapack_edit_entry(expected, 0, 0, UT_PI + 3);
    ulapack_edit_entry(expected, 0, 1, UT_PI);
    ulapack_edit_entry(expected, 0, 2, UT_PI);
    ulapack_edit_entry(expected, 1, 0, UT_PI);
    ulapack_edit_entry(expected, 1, 1, UT_PI + 3);
    ulapack_edit_entry(expected, 1, 2, UT_PI);
    ulapack_edit_entry(expected, 2, 0, UT_PI);
    ulapack_edit_entry(expected, 2, 1, UT_PI);
    ulapack_edit_entry(expected, 2, 2, UT_PI + 3);

    ulapack_is_equal(expected, result, &ret_value);

    ut_incr_error_ifnot(ret_value == ulapack_success,
        "Expected addition result doesn't equal actual.");

    #ifdef ULAPACK_USE_DYNAMIC_ALLOC
        ulapack_destroy(A);
        ulapack_destroy(B);
        ulapack_destroy(expected);
        ulapack_destroy(result);
        ulapack_destroy(result2);
    #endif

    return ulapack_success;
}

static MatrixError_t test_polyfit(void) {
    Matrix_t *x = NULL;
    Matrix_t *y = NULL;
    Matrix_t *p = NULL;

    /*
     * The number of data points.
     */
    const Index_t N = 30;

    /*
     * The degree of the polynomial to fit.
     */
    const Index_t n = 1;

    MatrixError_t ret_value;
    
    Index_t element = 0;

    const MatrixEntry_t x_data[] = {
        1.000000, 
        2.000000, 
        3.000000, 
        4.000000, 
        5.000000, 
        6.000000, 
        7.000000, 
        8.000000, 
        9.000000, 
        10.000000, 
        11.000000, 
        12.000000, 
        13.000000, 
        14.000000, 
        15.000000, 
        16.000000, 
        17.000000, 
        18.000000, 
        19.000000, 
        20.000000, 
        21.000000, 
        22.000000, 
        23.000000, 
        24.000000, 
        25.000000, 
        26.000000, 
        27.000000, 
        28.000000, 
        29.000000, 
        30.000000,};

    const MatrixEntry_t y_data[] = {
        0.764894, 
        5.877292, 
        9.609239, 
        15.889726, 
        25.277457, 
        36.087046, 
        49.173593, 
        64.453591, 
        80.396482, 
        99.202976,  
        121.360649,  
        145.885092,  
        168.693178,  
        194.987276,  
        224.761454,  
        255.515985,  
        288.672655,  
        324.475518,  
        360.869995,  
        399.405647,  
        440.556233,  
        482.677470,  
        528.140479,  
        574.586999,  
        624.484014,  
        674.914902,  
        728.292841,  
        783.698345,  
        839.799559,  
        899.980638,};

    println("Testing polynomial fitting.");

    #ifdef ULAPACK_USE_STATIC_ALLOC
        Matrix_t xmem;
        Matrix_t ymem;
        Matrix_t pmem;

        x = &xmem;
        y = &ymem;
        p = &pmem;

        ut_iserror(ulapack_init(x, N, 1));
        ut_iserror(ulapack_init(y, N, 1));
        ut_iserror(ulapack_init(p, n + 1, 1));

    #endif

    #ifdef ULAPACK_USE_DYNAMIC_ALLOC
        ut_iserror(ulapack_init(&x, N, 1));
        ut_iserror(ulapack_init(&y, N, 1));
        ut_iserror(ulapack_init(&p, n + 1, 1));
    #endif

    for (element = 0; element < N; element++) {
        ulapack_edit_entry(x, element, 0, x_data[element]);
        ulapack_edit_entry(y, element, 0, y_data[element]);
    }

    ret_value = ulapack_polyfit(x, y, n, p);
    if (ut_iserror(ret_value)) {
        return ret_value;
    }

    println("\np=");
    ulapack_print(p, stdout);

    #ifdef ULAPACK_USE_DYNAMIC_ALLOC
        ulapack_destroy(x);
        ulapack_destroy(y);
        ulapack_destroy(p);
    #endif

    return ulapack_success;
}


static MatrixError_t test_svd(void) {
    Matrix_t *A = NULL;
    Matrix_t *U = NULL;
    Matrix_t *S = NULL;
    Matrix_t *V = NULL;

    /*
     * The number of rows in A.
     */
    const Index_t N = 3;

    MatrixError_t ret_value;
    
    Index_t row_itor, col_itor = 0;

    const MatrixEntry_t Adata[6][3] = {{0.0120, 2.8743, 6.4553},
                                       {3.1642, 5.0166, 1.2322},
                                       {6.9962, 7.6155, 5.0440},
                                       {6.2526, 7.6241, 3.4726},
                                       {5.4306, 5.7606, 0.9215},
                                       {4.3904, 7.4766, 1.4785}};

    println("Testing SVD.");

    #ifdef ULAPACK_USE_STATIC_ALLOC
        Matrix_t Amem;
        Matrix_t Umem;
        Matrix_t Smem;
        Matrix_t Vmem;

        A = &Amem;
        U = &Umem;
        S = &Smem;
        V = &Vmem;

        ut_iserror(ulapack_init(A, N, N));
        ut_iserror(ulapack_init(U, N, N));
        ut_iserror(ulapack_init(S, N, 1));
        ut_iserror(ulapack_init(V, N, N));

    #endif

    #ifdef ULAPACK_USE_DYNAMIC_ALLOC
        ut_iserror(ulapack_init(&A, N, N));
        ut_iserror(ulapack_init(&U, N, N));
        ut_iserror(ulapack_init(&S, N, 1));
        ut_iserror(ulapack_init(&V, N, N));
    #endif

    for (row_itor = 0; row_itor < N; row_itor++) {
        for (col_itor = 0; col_itor < N; col_itor++) {
            ulapack_edit_entry(A, 
                row_itor, col_itor, 
                Adata[row_itor][col_itor]);
        }
    }

    println("A = ");
    ulapack_print(A, stdout);

    ret_value = ulapack_svd(A, U, S, V);
    if (ut_iserror(ret_value)) {
        return ret_value;
    }

    println("U =");
    ulapack_print(U, stdout);
    println("S =");
    ulapack_print(S, stdout);
    println("V =");
    ulapack_print(V, stdout);

    #ifdef ULAPACK_USE_DYNAMIC_ALLOC
        ulapack_destroy(A);

        ulapack_destroy(U);
        ulapack_destroy(S);
        ulapack_destroy(V);
    #endif

    return ulapack_success;
}

static MatrixError_t test_pca(void) {
    Matrix_t *A = NULL;
    Matrix_t *T = NULL;

    /*
     * The number of rows in A.
     */
    const Index_t N = 3;

    MatrixError_t ret_value;
    
    Index_t row_itor, col_itor = 0;

    const MatrixEntry_t Adata[3][3] = {{0.0120, 2.8743, 6.4553},
                                       {3.1642, 5.0166, 1.2322},
                                       {6.9962, 7.6155, 5.0440}};

    println("Testing PCA.");

    #ifdef ULAPACK_USE_STATIC_ALLOC
        Matrix_t Amem;
        Matrix_t Tmem;

        A = &Amem;
        T = &Tmem;

        ut_iserror(ulapack_init(A, N, N));
        ut_iserror(ulapack_init(T, N, N));

    #endif

    #ifdef ULAPACK_USE_DYNAMIC_ALLOC
        ut_iserror(ulapack_init(&A, N, N));
        ut_iserror(ulapack_init(&T, N, N));
    #endif

    for (row_itor = 0; row_itor < N; row_itor++) {
        for (col_itor = 0; col_itor < N; col_itor++) {
            ulapack_edit_entry(A, 
                row_itor, col_itor, 
                Adata[row_itor][col_itor]);
        }
    }

    println("A = ");
    ulapack_print(A, stdout);

    ret_value = ulapack_pca(A, T);
    if (ut_iserror(ret_value)) {
        return ret_value;
    }

    println("T =");
    ulapack_print(T, stdout);

    #ifdef ULAPACK_USE_DYNAMIC_ALLOC
        ulapack_destroy(A);
        ulapack_destroy(T);
    #endif

    return ulapack_success;
}

int ulapack_test(void)
{
    println("uLAPack Unit Tests.");
    #ifdef ULAPACK_USE_STATIC_ALLOC
        #ifdef ULAPACK_USE_DYNAMIC_ALLOC
            #error "Unit Test Error: More than one alloc type defined."
        #else
            println("Testing statically allocated structures.");
        #endif
    #endif

    #ifdef ULAPACK_USE_DYNAMIC_ALLOC
        #ifdef ULAPACK_USE_STATIC_ALLOC
            #error "Unit Test Error: More than one alloc type defined."
        #else
            println("Testing dynamically allocated structures.");
        #endif
    #endif
            

    if (test_initialization() != ulapack_success) {
        return ulapack_error;
    }
    if (test_basic_operations() != ulapack_success) {
        return ulapack_error;
    }
    if (test_polyfit() != ulapack_success) {
        return ulapack_error;
    }
    if (test_svd() != ulapack_success) {
        return ulapack_error;
    }
    if (test_pca() != ulapack_success) {
        return ulapack_error;
    }

    println("Total Unit Test errors: %llu", 
        (long long unsigned int)ut_error_counter);
    return 0;
}
