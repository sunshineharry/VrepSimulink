clc;
clear;
port = 19999;
InitSim;
object_name = 'L2';
relative_handle = -1;
[~, object_handle] = vrep.simxGetObjectHandle(clientID, object_name, vrep.simx_opmode_blocking);
