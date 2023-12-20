# 2023 DSD Final Project
---

## Directory Structure
- ```build``` : Vivado project directory
  - ```hw_test``` : Project for HW implementation
  - ```layer_tb``` : Simulation environment
    - ```fc_tb``` : Simulation environment for FC
    - ```conv_tb``` : Simulation environment for Conv
    - ```pool_tb``` : Simulation environment for Pool
  - The sources are pointing to the files in the ```src``` directory. Hence, if you open this project in Vivado & edit the code, the files in the ```src``` directory will be modified. Similarly, if you modify the files by using your own editor in the ```src``` directory, the changes will be applied when you open up the project

- ```src``` : Verilog source code 
  - ```common_ip``` : Directory containing IP files
  - ```constraints``` : Directory containing constraint files
  - ```ddr<2, 3>_mig``` : Directory containing DDR mig files
  - ```modules``` : Directory containing the HW modules
  - ```tb``` : Directory containing verilog codes for simulation
  - You only need to modify the files inside ```modules``` & ```tb```

- ```test``` : Python scripts for testing the programmed FPGA
  - ```cifar10_dataset_quan```: quantized dataset
  - ```cifar10_network_param```: network parameter
  - ```cifar10_network_quan_param```: quantized network parameter
  - ```new_cifar10_random_data```: additional quantized network parameters
  - If any errors appear while running these codes, check if all the package dependencies are installed
