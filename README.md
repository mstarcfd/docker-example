
ARCHIVED

Go to https://docs.mstarcfd.com/2_Installation/txt-files/Containers/mstar-ubuntu24-cuda12/README.html#docker-container 


# M-Star CFD Docker Container

This docker image can run the following M-Star components:

- M-Star CFD Python Pre API
- M-Star CFD Solver

Requirements:

- M-Star floating license
- Docker
- Nvidia Driver
- Nvidia Container Toolkit: https://docs.nvidia.com/datacenter/cloud-native/container-toolkit/install-guide.html#docker


## Build the image

    docker build -t mstar:1 . 

## Run

Modify the commands below to change the mstar_LICENSE environment variable to be your license server "port@host". 

Run the pre-processor API example:

    docker run --rm \
                -v $HOME/licenses:/licenses/ \
                -v $PWD:/w \
                -e mstar_LICENSE=/licenses/ \
                -e LOCAL_USER_ID=$(id -u) \
                -w /w \
                -it mstar:1 python3.9 create_test.py

Run the solver

    cd CASE/
    docker run --rm \
                --runtime=nvidia --gpus all \
                -v $HOME/licenses:/licenses/ \
                -v $PWD:/w \
                -e mstar_LICENSE=/licenses/ \
                -e LOCAL_USER_ID=$(id -u) \
                -w /w \
                -it mstar:1 mstar-cfd-mgpu --gpu-auto -i input.xml -o out --force
