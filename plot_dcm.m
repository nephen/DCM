%ATT数据格式为：{'LineNo';'TimeUS';'DesRoll';'Roll';'DesPitch';'Pitch';'DesYaw';'Yaw';'ErrRP';'ErrYaw'}
%IMU数据格式为：{'LineNo';'TimeUS';'GyrX';'GyrY';'GyrZ';'AccX';'AccY';'AccZ';'ErrG';'ErrA';'Temp';'GyHlt';'AcHlt'}
%AHR2数据格式为：{'LineNo';'TimeUS';'Roll';'Pitch';'Yaw';'Alt';'Lat';'Lng'}
%MAG数据格式为：{'LineNo';'TimeUS';'MagX';'MagY';'MagZ';'OfsX';'OfsY';'OfsZ';'MOfsX';'MOfsY';'MOfsZ';'Health'}
%其中ATT为EKF后在姿态，AHR2为DCM后在姿态
plot(ATT(:,2),ATT(:,4));        %打印姿态角,其中ATT(:,2)即为TimeUS，依次类推