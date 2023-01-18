# A simple library to link Simulink and Vrep/CoppeliaSim

## A simple demo to show Usage

### Operations in Vrep

I have a simple mechanism with two links shown in figure below. 

![image-20230118171043318](docs/images/image-20230118171043318-16740330473672.png)

All you have to do is open the main lua script and specify the port number. The default port is 19999.

![image-20230118171714383](docs/images/image-20230118171714383.png)

### Operations in MATLAB/Simulink

#### Step1: Add toolbox to MATLAB Path and Refresh the Simulink Library

If everything is ok, you will see Vreplib displayed in Simulink Library

![image-20230118172511603](docs/images/image-20230118172511603.png)

#### Step2: Create a new simulink model and set it to `Fixed-step`

![image-20230118172154710](docs/images/image-20230118172154710.png)

The `Fixed-step size` should be chose as same as the `dt` in Vrep.

![image-20230118172259049](docs/images/image-20230118172259049.png)

#### Set the InitFun of Simulink

1). Open the `Model Properties `

![image-20230118172759234](docs/images/image-20230118172759234.png)

2).  Add init function

![image-20230118172957670](docs/images/image-20230118172957670.png)

```matlab
port = 19999; % Change according to actual situation
InitSim;
```

#### Enjoy it !!!

You have to place the **Sync triger** module at the beginning of the model.

![image-20230118173154659](assets/image-20230118173154659.png)