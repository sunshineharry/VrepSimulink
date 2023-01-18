%% 初始化通讯

%% 加载Vrep提供的函数库
vrep = remApi('remoteApi');

%% 启动一个连接
% 关闭所有的潜在连接
vrep.simxFinish(-1);
% 建立连接
% 第一个参数是 Vrep 服务端的 IP 地址，如果是本机则为 127.0.0.1
% 第二个参数是端口号，对应 Vrep 脚本 sysCall_init 中的 simRemoteApi.start(19999)
% 第 3,4,5 个参数和超时等待相关
% 第六个参数是数据包通信频率，默认5ms
clientID = vrep.simxStart('127.0.0.1', port, true, true, 5000, 5);
% 判断连接是否成功
if (clientID <= -1)    % 连接失败
    msgbox("Connect to Vrep failed!","Error","error");
end

%% 以同步模式运行
vrep.simxSynchronous(clientID, true);