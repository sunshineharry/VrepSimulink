% 【注】：函数是将新的坐标系【设置到】某个位置，而不是在之前的基础上进行移动
function [sys,x0,str,ts] = SetObjectRotationByRPY(t,x,u,flag,vrep,clientID,object_name,relative_object_name)
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
    
    % 通过相对量计算绝对量
    [~,xyz] = vrep.simxGetObjectOrientation(clientID, object_handle, relative_handle, vrep.simx_opmode_blocking);
    R = rpy2r(u')*rotx(xyz(1))*roty(xyz(2))*rotz(xyz(3));
    finla_rpy = tr2rpy(R);
    
    % 控制
    vrep.simxSetObjectOrientation(clientID, object_handle, relative_handle, [finla_rpy(3),finla_rpy(2),finla_rpy(1)], vrep.simx_opmode_oneshot);

    sys = [];
end