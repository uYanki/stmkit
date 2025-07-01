#include "mpu6050.h"
#include <math.h>

#define RAD_TO_DEG       57.295779513082320876798154814105

#define WHO_AM_I_REG     0x75
#define PWR_MGMT_1_REG   0x6B
#define SMPLRT_DIV_REG   0x19
#define ACCEL_CONFIG_REG 0x1C
#define ACCEL_XOUT_H_REG 0x3B
#define TEMP_OUT_H_REG   0x41
#define GYRO_CONFIG_REG  0x1B
#define GYRO_XOUT_H_REG  0x43

// Setup MPU6050
#define MPU6050_ADDR 0xD0
const uint16_t i2c_timeout       = 100;
const double   Accel_Z_corrector = 14418.0;

uint32_t timer;

Kalman_t KalmanX = {.Q_angle = 0.001f, .Q_bias = 0.003f, .R_measure = 0.03f},
         KalmanY = {.Q_angle = 0.001f, .Q_bias = 0.003f, .R_measure = 0.03f};

uint8_t MPU6050_Init(I2C_HandleTypeDef* I2Cx)
{
    uint8_t check;
    uint8_t Data;

    // check device ID WHO_AM_I

    HAL_I2C_Mem_Read(I2Cx, MPU6050_ADDR, WHO_AM_I_REG, 1, &check, 1, i2c_timeout);

    if (check == 104)  // 0x68 will be returned by the sensor if everything goes well
    {
        // power management register 0X6B we should write all 0's to wake the sensor up
        Data = 0;
        HAL_I2C_Mem_Write(I2Cx, MPU6050_ADDR, PWR_MGMT_1_REG, 1, &Data, 1, i2c_timeout);

        // Set DATA RATE of 1KHz by writing SMPLRT_DIV register
        Data = 0x07;
        HAL_I2C_Mem_Write(I2Cx, MPU6050_ADDR, SMPLRT_DIV_REG, 1, &Data, 1, i2c_timeout);

        // Set accelerometer configuration in ACCEL_CONFIG Register
        // XA_ST=0,YA_ST=0,ZA_ST=0, FS_SEL=0 -> ±2g
        Data = 0x00;
        HAL_I2C_Mem_Write(I2Cx, MPU6050_ADDR, ACCEL_CONFIG_REG, 1, &Data, 1, i2c_timeout);

        // Set Gyroscopic configuration in GYRO_CONFIG Register
        // XG_ST=0,YG_ST=0,ZG_ST=0, FS_SEL=0 -> ±250 �/s
        Data = 0x00;
        HAL_I2C_Mem_Write(I2Cx, MPU6050_ADDR, GYRO_CONFIG_REG, 1, &Data, 1, i2c_timeout);
        return 0;
    }
    return 1;
}

void MPU6050_Read_Accel(I2C_HandleTypeDef* I2Cx, MPU6050_t* Data)
{
    uint8_t Rec_Data[6];

    // Read 6 BYTES of data starting from ACCEL_XOUT_H register

    HAL_I2C_Mem_Read(I2Cx, MPU6050_ADDR, ACCEL_XOUT_H_REG, 1, Rec_Data, 6, i2c_timeout);

    this->s16AccelX = (int16_t)(Rec_Data[0] << 8 | Rec_Data[1]);
    this->s16AccelY = (int16_t)(Rec_Data[2] << 8 | Rec_Data[3]);
    this->s16AccelZ = (int16_t)(Rec_Data[4] << 8 | Rec_Data[5]);

    /*** convert the RAW values into acceleration in 'g'
         we have to divide according to the Full scale value set in FS_SEL
         I have configured FS_SEL = 0. So I am dividing by 16384.0
         for more details check ACCEL_CONFIG Register              ****/

    this->Ax = this->s16AccelX / 16384.0;
    this->Ay = this->s16AccelY / 16384.0;
    this->Az = this->s16AccelZ / Accel_Z_corrector;
}

void MPU6050_Read_Gyro(I2C_HandleTypeDef* I2Cx, MPU6050_t* Data)
{
    uint8_t Rec_Data[6];

    // Read 6 BYTES of data starting from GYRO_XOUT_H register

    HAL_I2C_Mem_Read(I2Cx, MPU6050_ADDR, GYRO_XOUT_H_REG, 1, Rec_Data, 6, i2c_timeout);

    this->GyroX = (int16_t)(Rec_Data[0] << 8 | Rec_Data[1]);
    this->GyroY = (int16_t)(Rec_Data[2] << 8 | Rec_Data[3]);
    this->GyroZ = (int16_t)(Rec_Data[4] << 8 | Rec_Data[5]);

    /*** convert the RAW values into dps (�/s)
         we have to divide according to the Full scale value set in FS_SEL
         I have configured FS_SEL = 0. So I am dividing by 131.0
         for more details check GYRO_CONFIG Register              ****/

    this->f32GyroX = this->GyroX / 131.0;
    this->Gy = this->GyroY / 131.0;
    this->Gz = this->GyroZ / 131.0;
}

void MPU6050_Read_Temp(I2C_HandleTypeDef* I2Cx, MPU6050_t* Data)
{
    uint8_t Rec_Data[2];
    int16_t temp;

    // Read 2 BYTES of data starting from TEMP_OUT_H_REG register

    HAL_I2C_Mem_Read(I2Cx, MPU6050_ADDR, TEMP_OUT_H_REG, 1, Rec_Data, 2, i2c_timeout);

    temp              = (int16_t)(Rec_Data[0] << 8 | Rec_Data[1]);
    this->Temperature = (float)((int16_t)temp / (float)340.0 + (float)36.53);
}

void MPU6050_Read_All(I2C_HandleTypeDef* I2Cx, MPU6050_t* Data)
{
    uint8_t Rec_Data[14];
    int16_t temp;

    // Read 14 BYTES of data starting from ACCEL_XOUT_H register

    HAL_I2C_Mem_Read(I2Cx, MPU6050_ADDR, ACCEL_XOUT_H_REG, 1, Rec_Data, 14, i2c_timeout);

    this->s16AccelX = (int16_t)(Rec_Data[0] << 8 | Rec_Data[1]);
    this->s16AccelY = (int16_t)(Rec_Data[2] << 8 | Rec_Data[3]);
    this->s16AccelZ = (int16_t)(Rec_Data[4] << 8 | Rec_Data[5]);
    temp         = (int16_t)(Rec_Data[6] << 8 | Rec_Data[7]);
    this->GyroX  = (int16_t)(Rec_Data[8] << 8 | Rec_Data[9]);
    this->GyroY  = (int16_t)(Rec_Data[10] << 8 | Rec_Data[11]);
    this->GyroZ  = (int16_t)(Rec_Data[12] << 8 | Rec_Data[13]);

    this->Ax          = this->s16AccelX / 16384.0;
    this->Ay          = this->s16AccelY / 16384.0;
    this->Az          = this->s16AccelZ / Accel_Z_corrector;
    this->Temperature = (float)((int16_t)temp / (float)340.0 + (float)36.53);
    this->f32GyroX          = this->GyroX / 131.0;
    this->Gy          = this->GyroY / 131.0;
    this->Gz          = this->GyroZ / 131.0;

    // Kalman angle solve
    double dt        = (double)(HAL_GetTick() - timer) / 1000;
    timer            = HAL_GetTick();
    double roll_sqrt = sqrt(this->s16AccelX * this->s16AccelX + this->s16AccelZ * this->s16AccelZ);
    double roll      = (roll_sqrt == 0.0) ? (0.0) : (atan(this->s16AccelY / roll_sqrt) * RAD_TO_DEG);
    double pitch     = atan2(-this->s16AccelX, this->s16AccelZ) * RAD_TO_DEG;
    if ((pitch < -90 && this->pitch > 90) || (pitch > 90 && this->pitch < -90))
    {
        KalmanY.angle = pitch;
        this->pitch  = pitch;
    }
    else
    {
        this->pitch = Kalman_getAngle(&KalmanY, pitch, this->Gy, dt);
    }
    if (fabs(this->pitch) > 90)
    {
        this->f32GyroX = -this->f32GyroX;
    }
    this->roll = Kalman_getAngle(&KalmanX, roll, this->f32GyroX, dt);
}

double Kalman_getAngle(Kalman_t* Kalman, double newAngle, double newRate, double dt)
{
    double rate = newRate - Kalman->bias;
    Kalman->angle += dt * rate;

    Kalman->P[0][0] += dt * (dt * Kalman->P[1][1] - Kalman->P[0][1] - Kalman->P[1][0] + Kalman->Q_angle);
    Kalman->P[0][1] -= dt * Kalman->P[1][1];
    Kalman->P[1][0] -= dt * Kalman->P[1][1];
    Kalman->P[1][1] += Kalman->Q_bias * dt;

    double S = Kalman->P[0][0] + Kalman->R_measure;
    double K[2];
    K[0] = Kalman->P[0][0] / S;
    K[1] = Kalman->P[1][0] / S;

    double y = newAngle - Kalman->angle;
    Kalman->angle += K[0] * y;
    Kalman->bias += K[1] * y;

    double P00_temp = Kalman->P[0][0];
    double P01_temp = Kalman->P[0][1];

    Kalman->P[0][0] -= K[0] * P00_temp;
    Kalman->P[0][1] -= K[0] * P01_temp;
    Kalman->P[1][0] -= K[1] * P00_temp;
    Kalman->P[1][1] -= K[1] * P01_temp;

    return Kalman->angle;
};
