%ATT数据格式为：{'LineNo';'TimeUS';'DesRoll';'Roll';'DesPitch';'Pitch';'DesYaw';'Yaw';'ErrRP';'ErrYaw'}
%IMU数据格式为：{'LineNo';'TimeUS';'GyrX';'GyrY';'GyrZ';'AccX';'AccY';'AccZ';'ErrG';'ErrA';'Temp';'GyHlt';'AcHlt'}
%AHR2数据格式为：{'LineNo';'TimeUS';'Roll';'Pitch';'Yaw';'Alt';'Lat';'Lng'}
%MAG数据格式为：{'LineNo';'TimeUS';'MagX';'MagY';'MagZ';'OfsX';'OfsY';'OfsZ';'MOfsX';'MOfsY';'MOfsZ';'Health'}
%其中ATT为EKF后在姿态，AHR2为DCM后在姿态
figure('NumberTitle', 'off', 'Name', '飞控端DCM解算姿态');
subplot(3,1,1);
plot(AHR2(:,2),AHR2(:,3),'-g');%Roll        %打印DCM姿态角,其中AHR2(:,2)即为TimeUS，依次类推
title('Roll');
xlabel('Time/s');
ylabel('Angle/deg');
grid on;
subplot(3,1,2);
plot(AHR2(:,2),AHR2(:,4),'-r');%Pitch
title('Pitch');
xlabel('Time/s');
ylabel('Angle/deg');
grid on;
subplot(3,1,3);
plot(AHR2(:,2),AHR2(:,5),'-b');%Yaw
title('Yaw');
xlabel('Time/s');
ylabel('Angle/deg');
grid on;