FROM ubuntu:20.04

####### Base
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y  pkgconf wget curl ca-certificates         

####### CUDA
RUN wget https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb && \
    dpkg -i cuda-keyring*.deb && \
    apt-get update && \
    apt-get install -y --no-install-recommends \
    cuda-libraries-11-3 \
    cuda-libraries-dev-11-3 \
    cuda-minimal-build-11-3 \
    cuda-nvtx-11-3 \
    cuda-nvml-dev-11-3 \
    cuda-command-line-tools-11-3 && \
    ln -s cuda-11.3.1 /usr/local/cuda

####### Base
RUN apt-get update -y && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y  \
        openmpi-bin \
        libgtk-3-bin \
        libxkbcommon-x11-0 libxkbcommon0 libxmu6 libxxf86vm-dev libgl1 \
        libgtk-3-0 \
        openmpi-bin openmpi-common \
        python3.9 \
        gosu \
        && \
    rm -rf /var/lib/apt/lists/*

ENV LD_LIBRARY_PATH=/usr/local/cuda/lib:/usr/local/cuda/lib64:${LD_LIBRARY_PATH} \
    LIBRARY_PATH=/usr/local/cuda/lib64/stubs:${LIBRARY_PATH} \
    PATH=/usr/local/nvidia/bin:/usr/local/cuda/bin:${PATH}

####### MSTAR
WORKDIR /opt/mstar
RUN curl -s -L https://cdn.mstarcfd.com/3.8.67/mstarcfd_3.8.67_ubuntu18_cuda10.1_openmpi3.1.tar.gz | tar xz
ENV PATH /opt/mstar/bin:${PATH}
ENV LD_LIBRARY_PATH /opt/mstar/lib:${LD_LIBRARY_PATH}
ENV PYTHONPATH /opt/mstar/lib

COPY ./run-mstar.sh /usr/local/bin/run-mstar.sh
RUN chmod +x /usr/local/bin/run-mstar.sh
RUN ldconfig

####### Entry point ###############################################
WORKDIR /usr/local/bin/
COPY entry.sh docker-entrypoint.sh
RUN chmod +x docker-entrypoint.sh
ENTRYPOINT ["/usr/local/bin/docker-entrypoint.sh"]
###################################################################