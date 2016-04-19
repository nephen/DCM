clear;
clc;

load('test_data.mat');      %导入飞行数据
%ATT数据格式为：{'LineNo';'TimeUS';'DesRoll';'Roll';'DesPitch';'Pitch';'DesYaw';'Yaw';'ErrRP';'ErrYaw'}
%IMU数据格式为：{'LineNo';'TimeUS';'GyrX';'GyrY';'GyrZ';'AccX';'AccY';'AccZ';'ErrG';'ErrA';'Temp';'GyHlt';'AcHlt'}
%AHR2数据格式为：{'LineNo';'TimeUS';'Roll';'Pitch';'Yaw';'Alt';'Lat';'Lng'}
%MAG数据格式为：{'LineNo';'TimeUS';'MagX';'MagY';'MagZ';'OfsX';'OfsY';'OfsZ';'MOfsX';'MOfsY';'MOfsZ';'Health'}
%其中ATT为EKF后在姿态，AHR2为DCM后在姿态
imu_interval_s=0.02;
%时间间隔为0.02秒
%初始矩阵为地理坐标轴
dcmEst=[1 0 0; 0 1 0; 0 0 1];

imu_sequence = size(IMU,1);     %累积次数,通过读取数组在大小
mag_num = size(MAG,1);
discuss = ceil(imu_sequence/mag_num);       %商取整
graf(imu_sequence,4)=zeros;      %绘图数组初始化
ACC_WEIGHT=0.02;        %加速度计的权重
MAG_WEIGHT=0.01;         %磁力计的权重

for n = 1:imu_sequence          %循环imu_sequence次进行矩阵更新，如100，则进行100*0.02=2s，三轴变化应该为2，4，6
    Kacc = -IMU(n,[6,7,8]);     %导入原始加速度计的值
    Kacc = Kacc/norm(Kacc);     %加速度计向量归一化处理
    wA(3)=zeros;
    wA=cross(dcmEst(2,:),Kacc);     %wA = Kgyro x	 Kacc
    
    w(3) = zeros;
    w = -IMU(n,[3,4,5]);        %导入原始陀螺仪的值
          
    %导入磁力计的数据，注意SD卡里并没有IMU那么多数据，必须除以它们的商值
    z = ceil(n/discuss);
    %限幅
    if z <= 1
        z = 1;
    elseif z >= mag_num
            z = mag_num;
    end
    Imag = MAG(z,[3,4,5]);
    Imag = Imag/norm(Imag);     %磁力计数据归一化处理
    wM(3) = zeros;
    wM=cross(dcmEst(1,:),Imag);     %wM = Igyro x Imag
    
    Theta=(w*imu_interval_s + wA*ACC_WEIGHT + wM*MAG_WEIGHT)/(1+ACC_WEIGHT+MAG_WEIGHT);   %在时间间隔的角度变化向量，取权重值
    
    dR(3)=zeros;
    for k = 1:3
        dR=cross(Theta,dcmEst(k,:));        %向量叉乘
        dcmEst(k,:)=dcmEst(k,:)+dR;     %累加
    end
    %误差计算
    error=-dot(dcmEst(1,:),dcmEst(2,:))*0.5;
    %误差校正
    x_est = dcmEst(2,:) * error;
    y_est = dcmEst(1,:) * error;
    dcmEst(1,:) = dcmEst(1,:) + x_est;
    dcmEst(2,:) = dcmEst(2,:) + y_est;
    %正交化
    dcmEst(3,:) = cross(dcmEst(1,:), dcmEst(2,:));
    if 1
        %泰勒展开归一化处理
        dcmEst(1,:)=0.5*(3-dot(dcmEst(1,:),dcmEst(1,:))) * dcmEst(1,:);
        dcmEst(2,:)=0.5*(3-dot(dcmEst(2,:),dcmEst(2,:))) * dcmEst(2,:);
        dcmEst(3,:)=0.5*(3-dot(dcmEst(3,:),dcmEst(3,:))) * dcmEst(3,:);
    else
        %平方和
        dcmEst(1,:)=dcmEst(1,:)/norm(dcmEst(1,:));
        dcmEst(2,:)=dcmEst(2,:)/norm(dcmEst(2,:));
        dcmEst(3,:)=dcmEst(3,:)/norm(dcmEst(3,:));
    end

    %转换为欧拉角
    graf(n,1)=n*imu_interval_s;
    %graf(n,2)=atan2(dcmEst(3,2),dcmEst(3,3));      %yaw   
    %graf(n,3)=-asin(dcmEst(3,1));      %pitch               
    %graf(n,4)=atan2(dcmEst(2,1),dcmEst(1,1));      %roll
    %使用matlab方法：[yaw, pitch, roll] = dcm2angle(dcm)
    %[graf(n,2),graf(n,3),graf(n,4)] = dcm2angle(dcmEst);
    %使用四元数进行转换
    q = dcm2quat(dcmEst);
    [graf(n,2),graf(n,3),graf(n,4)] = quat2angle(q);
end

figure('NumberTitle', 'off', 'Name', 'Matlab端DCM解算姿态');
subplot(3,1,1);
%转换为角度并绘图，为了与飞控的算法对比，结果取反了
plot(graf(:,1),-graf(:,4)*(180/pi),'-g');%roll
grid on;
subplot(3,1,2);
plot(graf(:,1),-graf(:,3)*(180/pi),'-r');%pitch
grid on;
subplot(3,1,3);
plot(graf(:,1),-graf(:,2)*(180/pi),'-b');%yaw
grid on;
plot_dcm;