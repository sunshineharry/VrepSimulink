% 【注】：函数是将新的坐标系【设置到】某个位置，而不是在之前的基础上进行移动
function [sys,x0,str,ts] = SetObjectOrientationByRPY(t,x,u,flag,vrep,clientID,object_name,relative_object_name)
    switch flag
        case 0
            [sys,x0,str,ts]=mdlInitializeSizes;
        case 1
            sys=mdlDerivatives(t,x,u);    
        case 2
            sys=mdlUpdate(t,x,u);
        case 3
            sys=mdlOutputs(t,x,u,vrep,clientID,object_name,relative_object_name);
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
    sizes.NumOutputs     = 0;
    sizes.NumInputs      = 3;
    sizes.DirFeedthrough = 1;
    sizes.NumSampleTimes = 1;
    sys = simsizes(sizes); 
    x0  = [];
    str = [];
    ts  = [0 0];
end

function sys = mdlUpdate(~,~,~)
    sys = [];
end

function sys = mdlOutputs(~,~,u,vrep,clientID,object_name,relative_object_name)
    % 获取物体的句柄
    [~, object_handle] = vrep.simxGetObjectHandle(clientID, object_name, vrep.simx_opmode_blocking);
    
    % 获取参考系的句柄
    if strcmp(relative_object_name, 'world')        % 相对于世界坐标系
        relative_handle = -1;
    elseif strcmp(relative_object_name, 'parent')   % 相对于父坐标系
        relative_handle = vrep.sim_handle_parent;
    else
        [~, relative_handle] = vrep.simxGetObjectHandle(clientID, relative_object_name, vrep.simx_opmode_blocking);
    end
    
    % 控制，我不理解为什么官方手册说的是欧拉角，根据官方手册，（https://www.coppeliarobotics.com/helpFiles/en/positionOrientationTransformation.htm）
    % R = Rx*Ry*Rz
    % RPY为 u = [roll, pitch, yaw]
    % R = Rotx(yaw) * Roty(pitch) * Rotz(roll)
    vrep.simxSetObjectOrientation(clientID, object_handle, relative_handle, [u(3),u(2),u(1)], vrep.simx_opmode_oneshot);

    sys = [];
end