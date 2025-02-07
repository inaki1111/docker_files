# Use ROS 2 Jazzy full desktop image
FROM osrf/ros:jazzy-desktop-full

# Install necessary packages
RUN apt-get update && apt-get install -y \
    git \
    nano \
    ros-jazzy-moveit \
    ros-jazzy-librealsense2*

# Set environment variables
ENV COLCON_WS=/ur_gz
ENV ROS2_WS=/ros2_ws

# Create and configure the UR5 Gazebo workspace
RUN mkdir -p $COLCON_WS/src
WORKDIR $COLCON_WS

# Clone the UR5 Gazebo Sim repository
RUN git clone -b ros2 https://github.com/UniversalRobots/Universal_Robots_ROS2_GZ_Simulation.git src/ur_simulation_gz

# Install dependencies
RUN apt-get update && \
    rosdep update && \
    rosdep install --ignore-src --from-paths src -y \
    && rm -rf /var/lib/apt/lists/*  # Clean cache

# Build the UR5 workspace
RUN /bin/bash -c "source /opt/ros/jazzy/setup.bash && colcon build --symlink-install"

# Create and configure the main ROS 2 workspace
WORKDIR $ROS2_WS
RUN mkdir -p src
WORKDIR $ROS2_WS/src

# Clone your custom repositories
RUN git clone https://github.com/inaki1111/detection.git
RUN git clone https://github.com/IntelRealSense/realsense-ros.git -b ros2-master

WORKDIR $ROS2_WS

# Install dependencies for ros2_ws
RUN apt-get update && \
    rosdep update && \
    rosdep install --from-paths src --ignore-src -r -y \
    && rm -rf /var/lib/apt/lists/*  # Clean cache

# Build the main ROS 2 workspace
RUN /bin/bash -c "source /opt/ros/jazzy/setup.bash && colcon build --symlink-install"

# Source ROS 2 setup on container start
RUN echo "source /opt/ros/jazzy/setup.bash" >> ~/.bashrc
RUN echo "source $ROS2_WS/install/setup.bash" >> ~/.bashrc
RUN echo "source $COLCON_WS/install/setup.bash" >> ~/.bashrc  # Keep both workspaces accessible



# Default command: keep the container running
CMD ["/bin/bash"]


# gazebo models https://app.gazebosim.org/fuel/models