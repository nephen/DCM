%ATT数据格式为：TimeUS,DesRoll,Roll,DesPitch,Pitch,DesYaw,Yaw,ErrRP,ErrYaw
%IMU数据格式为：TimeUS,GyrX,GyrY,GyrZ,AccX,AccY,AccZ,ErrG,ErrA,Temp,GyHlt,AcHlt
%AHR2数据格式为：TimeUS,Roll,Pitch,Yaw,Alt,Lat,Lng
plot(ATT(:,2),ATT(:,4));        %打印姿态角,其中ATT(:,2)即为TimeUS，依次类推