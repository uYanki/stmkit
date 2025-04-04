# [Micro Linear Algebra Package](https://github.com/SargisYonan/uLAPack)

用于计算各种矩阵/向量运算的小型线性代数包。

### Included Functionality

μLAPack contains functionality to assist in your matrix math needs for feedback control, statistical analysis, data processing, filtering, estimation, basic algebraic computation, and machine learning.

#### Library Specific Functions

* Initialize a matrix/vector object - `ulapack_initialize`
* Print a matrix/vector to an output file stream - `ulapack_print`
* Free dynamically allocated matrix/vector memory - `ulapack_destroy`
* Safely edit a matrix/vector element - `ulapack_edit_entry`
* Safely modify a matrix/vector element - `ulapack_get_entry`
* Query an object to see if it is a vector - `ulapack_is_vector`
* Copy the contents of a matrix or vector - `ulapack_copy`
* Copy data from an array to a matrix column - `ulapack_array_col_copy`
* Copy data from an array to a matrix row - `ulapack_array_row_copy`

#### Basic Matrix/Vector Operations

* Get the size of a matrix or vector - `ulapack_size`
* Check if two matrices or vectors are equal in value - `ulapack_is_equal`

##### Arithmetic

* Sum the elements of a matrix or vector - `ulapack_sum`
* Add two matrices or vectors - `ulapack_add`
* Subtract two matrices or vectors - `ulapack_subtract`
* Take the trace of a matrix - `ulapack_trace`
* Take the product of two matrices or vectors - `ulapack_product`
* Take the inner product of two vectors - `ulapack_dot`
* Take the norm of a vector or Frobenius norm of a matrix - `ulapack_norm`
* Find the determinant of a Matrix - `ulapack_det`
* Scale a matrix or vector by a scalar - `ulapack_scale`

##### Manipulations

* Put a vector on the diagonal of a matrix - `ulapack_diag`
* Set a square matrix to the identity matrix - `ulapack_eye` 
* Safely set the entirety of matrix/vector to a single value - `ulapack_set`
* Take the transpose of a matrix or vector - `ulapack_transpose`
* Take the inverse of a matrix - `ulapack_inverse`
* Take the pseudo inverse of a matrix - `ulapack_pinverse`

#### Advanced Operations

* Decompose a matrix into LU triangular matrices - `ulapack_lu`
* Create a Vandermonde matrix from a vector - `ulapack_vandermonde`
* Compute the least squares of a matrix/system - `ulapack_least_squares`
* Fit an nth degree polynomial - `ulapack_polyfit`
* Decompose a matrix via Singular Value Decomposition (SVD) - `ulapack_svd`
* Compute a score matrix via Principle Component Analysis (PCA) - `ulapack_pca`