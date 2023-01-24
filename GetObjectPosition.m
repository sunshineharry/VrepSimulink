function [sys,x0,str,ts] = GetObjectPosition(t,x,u,flag,vrep,clientID,object_name,relative_object_name)
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
    sizes.NumOutputs     = 3;
    sizes.NumInputs      = 0;
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

function sys = mdlOutputs(~,~,~,vrep,clientID,object_name,relative_object_name)
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
    
    % 获取相对位置
    [~, position] = vrep.simxGetObjectPosition(clientID, object_handle, relative_handle, vrep.simx_opmode_blocking);
    
    % 输出
    sys = double(position);
end