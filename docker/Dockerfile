# syntax=docker/dockerfile:1
FROM docker.io/ros:jazzy

# install tools and libraries
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
    vim git ffmpeg clang gdb cmake python3-pip python3-venv rapidjson-dev \
    libzmq3-dev libeigen3-dev libopencv-dev libomp-dev libpcap-dev libsdl2-dev \
    opencl-headers ocl-icd-opencl-dev intel-opencl-icd libgstreamer1.0-dev \
    libgstrtspserver-1.0-dev gstreamer1.0-plugins-base gstreamer1.0-plugins-good \
    gstreamer1.0-plugins-bad gstreamer1.0-plugins-ugly
RUN update-alternatives --set c++ /usr/bin/clang++

# install ROS components
RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get install -y \
    ros-jazzy-common-interfaces ros-jazzy-rviz2 ros-jazzy-pcl-ros \
    ros-jazzy-cv-bridge ros-jazzy-image-transport-plugins

# install python libraries
RUN python3 -m venv /venv

# pip 缓存挂载 + 重试：torch 的 CUDA 依赖有 2~3GB，网络抖动时不要让整层作废重下
RUN --mount=type=cache,target=/root/.cache/pip \
    set -eux; \
    ok=0; \
    for i in 1 2 3 4 5; do \
        if /venv/bin/pip install --timeout 120 --retries 20 \
               -i https://pypi.tuna.tsinghua.edu.cn/simple \
               ultralytics==8.4.100 pygame pyzmq vidgear; then ok=1; break; fi; \
        echo "==> pip attempt $i failed, retrying in 10s"; sleep 10; \
    done; \
    [ "$ok" = 1 ]

RUN --mount=type=cache,target=/root/.cache/pip \
    /venv/bin/pip install --timeout 120 --retries 20 \
        -i https://pypi.tuna.tsinghua.edu.cn/simple \
        catkin_pkg empy lark
ENV PATH="/venv/bin:$PATH"

# clear cache
RUN rm -rf /var/lib/apt/lists/*

USER ubuntu
WORKDIR /ws
ENTRYPOINT ["bash"]
