# Usar la imagen completa de ROS Humble con entorno gráfico
FROM osrf/ros:humble-desktop-full

# Actualizar lista de paquetes y herramientas necesarias
RUN apt-get update && apt-get install -y \
    git \
    nano \
    python3-rosdep2 \
    usbutils \
    ros-humble-ros-gz \
    ros-humble-urdf \
    ros-humble-xacro \
    ros-humble-realsense2-camera \
    ros-humble-realsense2-description

# Configurar rosdep para manejar dependencias
RUN rosdep init || true && rosdep update

# Crear y configurar el workspace de ROS 2
WORKDIR /ros2_ws
RUN mkdir -p src

WORKDIR /ros2_ws/src
RUN git clone https://github.com/inaki1111/detection.git


WORKDIR /ros2_ws

# Instalar dependencias del paquete
RUN rosdep install --from-paths src --ignore-src -r -y

# Compilar con colcon build
RUN /bin/bash -c "source /opt/ros/humble/setup.bash && colcon build"

# Agregar el workspace al entorno
RUN echo "source /ros2_ws/install/setup.bash" >> /root/.bashrc

# Limpiar caché de APT para reducir el tamaño de la imagen
RUN rm -rf /var/lib/apt/lists/*

# Volver al home
WORKDIR /root

# Mantener el contenedor abierto
CMD ["/bin/bash"]
