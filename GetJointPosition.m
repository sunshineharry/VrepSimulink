function [sys,x0,str,ts] = GetJointPosition(t,x,u,flag,vrep,clientID,joint_name,is_use_radian)
    switch flag
        case 0
            [sys,x0,str,ts]=mdlInitializeSizes;
        case 1
            sys=mdlDerivatives(t,x,u);    
        case 2
            sys=mdlUpdate(t,x,u);
        case 3
            sys=mdlOutputs(t,x,u,vrep,clientID,joint_name,is_use_radian);
        case {4,9}
            sys=[];
        otherwise
            error(['Unhandled flag = ',num2str(flag)]);
    end
end

function [sys,x0,str,ts] = mdlInitializeSizes
    sizes = simsizes;           
    sizes.NumContStates  = 0;   
    sizes.NumDiscStates  = 0; 
    sizes.NumOutputs     = 1;
    sizes.NumInputs      = 0;
    sizes.DirFeedthrough = 1;
    sizes.NumSampleTimes = 1;
    sys = simsizes(sizes); 
    x0  = [];
    str = [];
    ts  = [0 0];
end

function sys = mdlUpdate(t,x,u)
    sys = [];
end

function sys = mdlOutputs(t,x,u,vrep,clientID,joint_name,is_use_radian)
    % 获取句柄，你要对什么对象进行操作，需要先获取句柄
    [res, joint_handle] = vrep.simxGetObjectHandle(clientID, joint_name, vrep.simx_opmode_blocking);
    [returnCode, position] = vrep.simxGetJointPosition(clientID, joint_handle, vrep.simx_opmode_blocking);
    if t==0
        sys(1) = 0;
        return;
    end
    if is_use_radian
        sys(1) = double(position);
    else
        sys(1) = double(rad2deg(position));
    end
end