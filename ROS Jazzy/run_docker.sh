#!/bin/bash

# This script is used to run the docker container with the ROS2 Jazzy image
# gives permission to use the display


xhost +local:root
docker run -it --privileged     --env="DISPLAY=$DISPLAY"     --env="QT_X11_NO_MITSHM=1"     --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw"     ros2_jazzy
