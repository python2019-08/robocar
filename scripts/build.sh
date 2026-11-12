#!/bin/bash

BUILD_TYPE=$1

# ROS 2 Jazzy is built against the system python3 (3.12). If a conda env (or any
# other python3) comes first on PATH, CMake picks that interpreter instead and
# configure fails with "No module named 'catkin_pkg'" / "'em'". Force the system
# python3 for both PATH lookups and CMake's FindPython3.
export PATH="/usr/bin:$PATH"
PYTHON3=/usr/bin/python3

source /opt/ros/jazzy/setup.bash

if [ "$BUILD_TYPE" = "debug" ]; then
	colcon build --cmake-args ' -Wno-dev' ' -DCMAKE_BUILD_TYPE=Debug' \
		" -DPython3_EXECUTABLE=$PYTHON3" " -DPYTHON_EXECUTABLE=$PYTHON3"
elif [ "$BUILD_TYPE" = "release" ]; then
	colcon build --cmake-args ' -Wno-dev' ' -DCMAKE_BUILD_TYPE=Release' \
		" -DPython3_EXECUTABLE=$PYTHON3" " -DPYTHON_EXECUTABLE=$PYTHON3"
else
	echo "invalid build type: '$BUILD_TYPE'"
fi
