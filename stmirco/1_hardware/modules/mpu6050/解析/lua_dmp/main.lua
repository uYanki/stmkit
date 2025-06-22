PROJECT = "DMP"
VERSION = "1.0.0"

_G.sys = require("sys")

log.info("--------------")

i2c_id = 0

pitch, roll, yaw = 0, 0, 0

function dmp_init(addr)
    if i2c.setup(i2c_id, i2c.FAST, addr) == 1 then
        i2c.send(i2c_id, addr, data)
        i2c.send(i2c_id, addr, data)
        log.info('mpu6050 ok')
        return 1
    end
    log.info('mpu6050 err')
    return 0
end

sys.taskInit(function() dmp_init(0x68) end)

sys.run()
