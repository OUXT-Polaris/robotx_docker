FROM nvidia/opengl:1.0-glvnd-devel-ubuntu16.04

MAINTAINER Shuhei Horiguchi <shuhei.horiguchi@outlook.com>

ENV LANG=C.UTF-8 \
    LC_ALL=C.UTF-8 \
    ROS_DISTRO=kinetic \
    DEBIAN_FRONTEND=noninteractive \
    USER_NAME=ubuntu

RUN apt-get update && apt-get install -q -y \
    apt-utils \
    dirmngr \
    gnupg2 \
    lsb-release \
    lxde-core \
    tightvncserver \
    wget \
    && rm -rf /var/lib/apt/lists/*

# install ros-kinetic
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 421C365BD9FF1F717815A3895523BAEEB01FA116

RUN echo "deb http://packages.ros.org/ros/ubuntu `lsb_release -sc` main" > /etc/apt/sources.list.d/ros-latest.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    ros-kinetic-desktop-full \
    && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install --no-install-recommends -y \
    python-rosinstall \
    python-rosinstall-generator \
    python-wstool \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

RUN rosdep init
RUN useradd -m $USER_NAME && \
    echo "${USER_NAME} ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers.d/${USER_NAME}

USER $USER_NAME
RUN rosdep update

RUN echo "source /opt/ros/$ROS_DISTRO/setup.bash" >> /home/$USER_NAME/.bashrc
RUN mkdir -p /home/$USER_NAME/catkin_ws/src
WORKDIR /home/$USER_NAME/catkin_ws/src
RUN git clone https://github.com/OUXT-Polaris/robotx_packages.git
WORKDIR /home/$USER_NAME/catkin_ws/

RUN rosdep install -i -r -y --from-paths src --rosdistro kinetic

USER $USER_NAME
RUN /bin/bash -c ". /opt/ros/$ROS_DISTRO/setup.bash && \
    rm -rf devel build && \
    catkin_make_isolated"
RUN source devel_isolated/setup.bash

# install TurboVNC
#RUN wget https://sourceforge.net/projects/virtualgl/files/2.5.2/virtualgl32_2.5.2_amd64.deb && \
#    dpkg -i virtualgl32_2.5.2_amd64.deb && \
#    rm virtualgl32_2.5.2_amd64.deb
#RUN wget https://sourceforge.net/projects/turbovnc/files/2.1.2/turbovnc_2.1.2_amd64.deb && \
#    dpkg -i turbovnc_2.1.2_amd64.deb && \
#    rm dpkg -i turbovnc_2.1.2_amd64.deb

#RUN init 3
#RUN vglserver_config

CMD ["bash"]
