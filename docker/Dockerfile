FROM bevformer:latest


ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Europe/Stockholm
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

ENV NVIDIA_DRIVER_CAPABILITIES ${NVIDIA_DRIVER_CAPABILITIES},compute,display

SHELL [ "/bin/bash", "--login", "-c" ]

# Install UniAD from source
WORKDIR /
# RUN git clone https://github.com/OpenDriveLab/UniAD.git
WORKDIR /UniAD
COPY requirements.txt /UniAD/requirements.txt
RUN pip install -r requirements.txt
# We need this old version of torchmetrics to run UniAD...
RUN pip install torchmetrics==0.8.2
RUN LD_PRELOAD=/usr/lib/x86_64-linux-gnu/libstdc++.so.6.0.28
# Link python to python3
RUN ln /usr/bin/python3 /usr/bin/python
