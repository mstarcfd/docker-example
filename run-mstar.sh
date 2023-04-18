#!/bin/bash

nvidia-smi

mpirun -np $1 mstar-cfd-mgpu --gpu-auto -i input.xml -o out 2>&1 |tee log.txt