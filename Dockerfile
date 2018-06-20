FROM nvidia/opengl:1.0-glvnd-devel-ubuntu16.04

MAINTAINER Shuhei Horiguchi <shuhei.horiguchi@outlook.com>

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    ROS_DISTRO=kinetic \
    DEBIAN_FRONTEND=noninteractive

# install ros-kinetic
RUN apt-get update && apt-get install -q -y \
    dirmngr \
    gnupg2 \
    lsb-release \
    && rm -rf /var/lib/apt/lists/*

RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116

RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
#    python-catkin-tools \
    ros-kinetic-desktop-full \
    && rm -rf /var/lib/apt/lists/*

RUN rosdep init \
    && rosdep update

RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /root/.bashrc
RUN mkdir -p /root/catkin_ws/src
WORKDIR /root/catkin_ws/src
RUN git clone https://github.com/OUXT-Polaris/robotx_packages.git
WORKDIR /root/catkin_ws/
RUN rosdep install -i -r -y --from-paths src --rosdistro kinetic
RUN catkin_make

CMD ["bash"]
