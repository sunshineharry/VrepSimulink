function [sys,x0,str,ts] = SyncTriger(t,x,u,flag,vrep,clientID)
% s-Function 的入口
% 函数的四个输入分别为采样时间t、状态x、输入u和仿真流程控制标志变量flag
% 函数的四个输出分别为：
%   sys数组包含某个子函数返回的值
%   x0为所有状态的初始化向量
%   str是保留参数，总是一个空矩阵
%   Ts返回系统采样时间
    switch flag
        case 0
            [sys,x0,str,ts]=mdlInitializeSizes;
        case 1
            sys=mdlDerivatives(t,x,u);    
        case 2
            sys=mdlUpdate(t,x,u,vrep,clientID);
        case 3
            sys=mdlOutputs(t,x,u);
        case {4,9}
            sys=[];
        otherwise
            error(['Unhandled flag = ',num2str(flag)]);
    end
end

%% 初始化回调子函数
% 提供状态、输入、输出、采样时间数目和初始状态的值
% 初始化阶段，标志变量flag首先被置为0，S-function首次被调用时
% 该子函数首先被调用，且为S-function模块提供下面信息
% 该子函数必须存在
function [sys,x0,str,ts] = mdlInitializeSizes
    sizes = simsizes;           % 生成sizes数据结构，信息被包含在其中
    sizes.NumContStates  = 0;   % 连续状态数，缺省为0
    sizes.NumDiscStates  = 0;   % 离散状态数，缺省为0
    sizes.NumOutputs     = 0;   % 输出个数，缺省为0
    sizes.NumInputs      = 0;   % 输入个数，缺省为0
    sizes.DirFeedthrough = 1;   % 是否存在直馈通道，1存在，0不存在
    sizes.NumSampleTimes = 1;   % 采样时间个数，至少是一个
    sys = simsizes(sizes);      % 返回size数据结构所包含的信息
    x0  = [];                   % 设置初始状态
    str = [];                   % 保留变量置空
    ts  = [0 0];                %设置采样时间
end

%% 状态更新回调子函数
% 给定t、x、u计算离散状态的更新
% 每个仿真步内必然调用该子函数，不论是否有意义
% 除了在此描述系统的离散状态方程外，还可以在此添加其他每个仿真步内都必须执行的代码
function sys = mdlUpdate(t,x,u,vrep,clientID)
    vrep.simxSynchronousTrigger(clientID);
    sys = [];
end

%% 计算输出回调函数
% 给定t,x,u计算输出，可以在此描述系统的输出方程
% 该子函数必须存在
function sys = mdlOutputs(t,x,u)
    sys = [];
end
