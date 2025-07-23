FROM nvidia/cuda:11.8.0-cudnn8-devel-ubuntu20.04


# setup timezone
ENV TZ=US/Pacific
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# --- 关键修改：替换为阿里云镜像源 ---
    RUN sed -i "s@http://.*archive.ubuntu.com@http://mirrors.aliyun.com@g" /etc/apt/sources.list && \
    sed -i "s@http://.*security.ubuntu.com@http://mirrors.aliyun.com@g" /etc/apt/sources.list

# 添加阿里云工具链PPA镜像
RUN echo "deb http://mirrors.aliyun.com/ubuntu/ focal main restricted universe multiverse" > /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-security main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-updates main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-proposed main restricted universe multiverse" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.aliyun.com/ubuntu/ focal-backports main restricted universe multiverse" >> /etc/apt/sources.list

SHELL ["/bin/bash", "-c"]


# Required to build Ubuntu 20.04 without user prompts with DLFW container
ENV DEBIAN_FRONTEND=noninteractive

# To fix GPG key error when running apt-get update
# RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/cuda/repos/ubuntu1804/x86_64/3bf863cc.pub
# RUN apt-key adv --fetch-keys https://developer.download.nvidia.com/compute/machine-learning/repos/ubuntu1804/x86_64/7fa2af80.pub

# Install requried libraries
# 安装基本工具和依赖 - 合并为单个RUN层减少镜像层数
RUN apt-get update -y && \
    apt-get install -y --no-install-recommends \
        software-properties-common \
        wget \
        curl \
        ca-certificates \
        gnupg \
        apt-transport-https && \
    # 添加工具链PPA密钥
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 1E9377A2BA9EF27F && \
    add-apt-repository ppa:ubuntu-toolchain-r/test && \
    # 更新并安装主要依赖
    apt-get update -y && \
    apt-get install -y --no-install-recommends \
        libcurl4-openssl-dev \
        zlib1g-dev \
        git \
        sudo \
        ssh \
        libssl-dev \
        pbzip2 \
        pv \
        bzip2 \
        unzip \
        devscripts \
        lintian \
        fakeroot \
        dh-make \
        build-essential \
        libx11-6 \
        nano \
        graphviz \
        libgl1-mesa-glx \
        openssh-server \
        libgtk2.0-0 \
        libcanberra-gtk-module \
        libsm6 \
        libxext6 \
        libxrender-dev \
        libgtk2.0-dev \
        pkg-config \
        libibverbs-dev && \
    # 清理缓存减小镜像大小
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install Miniconda
# 安装 Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh && \
    bash Miniconda3-latest-Linux-x86_64.sh -b -p /opt/conda && \
    rm Miniconda3-latest-Linux-x86_64.sh

# 设置环境变量
ENV PATH=/opt/conda/bin:$PATH

# 接受服务条款
RUN conda init bash && \
    conda config --set always_yes yes --set changeps1 no && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/main && \
    conda tos accept --override-channels --channel https://repo.anaconda.com/pkgs/r

# 创建并激活环境
RUN conda create -n uniad2.0 python=3.9
ENV CONDA_DEFAULT_ENV=uniad2.0 
ENV CONDA_PREFIX=/opt/conda/envs/$CONDA_DEFAULT_ENV
ENV PATH=$CONDA_PREFIX/bin:$PATH

# Set environment and working directory
ENV CUDA_HOME=/usr/local/cuda
ENV LD_LIBRARY_PATH=$CUDA_HOME/lib64:$CUDA_HOME/extras/CUPTI/lib64/:$LD_LIBRARY_PATH
ENV PATH=$CUDA_HOME/bin:$PATH
ENV CFLAGS="-I$CUDA_HOME/include $CFLAGS"
ENV FORCE_CUDA="1"
ENV PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/root/miniconda3/envs/bin:$PATH

# install pytorch
RUN pip install torch==2.0.1 torchvision==0.15.2 torchaudio==2.0.2 --index-url https://download.pytorch.org/whl/cu118

# install opencv
RUN python -m pip install opencv-python==4.5.5.62

# install gcc
# RUN conda install -c omgarcia gcc-6

ENV MMCV_WITH_OPS=1 
ENV MMCV_CUDA_ARGS=-std=c++17
ENV CXXFLAGS='-std=c++17'
ENV _GLIBCXX_USE_CXX11_ABI=1
# 40x系列需要下面的参数
ENV TORCH_CUDA_ARCH_LIST="8.9"
# RUN git clone --branch v1.6.0 --single-branch https://github.com/open-mmlab/mmcv.git
# WORKDIR /mmcv
# RUN pip install -v -e .
RUN pip install mmcv-full==1.6.0 -f https://download.openmmlab.com/mmcv/dist/cu118/torch2.0/index.html
RUN pip install mmdet==2.26.0 mmsegmentation==0.29.1 mmdet3d==1.0.0rc6

# install other dependencies
COPY . /UniAD
WORKDIR /UniAD
RUN pip install -r requirements.txt
WORKDIR /UniAD
USER root
RUN ["/bin/bash"]