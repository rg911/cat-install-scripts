#!/bin/bash

install_path=${HOME}

# region base dependencies

function update_apt {
    echo "Upgrading and updating apt dependencies "
    echo
    
    apt update -y
    apt upgrade -y
}

function install_apt_dependency {
    echo "Installing apt dependencies: "
    echo ${base_deps[@]}
    echo
    apt install ${base_deps[@]} -y
}

function install_base_deps {
    base_deps=(autoconf libtool cmake curl git xz-utils
        libatomic-ops-dev libunwind-dev g++ gdb libgflags-dev
        libsnappy-dev ninja-build python3 python3-ply build-essential
        python-dev libxml2-dev libxslt-dev)
    install_apt_dependency
}

# endregion


# region gcc

function install_gcc {
    gcc_version=9
    echo "Installing GCC ${gcc_version}"
    echo
    
    # courtesy of: https://linuxize.com/post/how-to-install-gcc-compiler-on-ubuntu-18-04/

    sudo apt install software-properties-common
    sudo add-apt-repository ppa:ubuntu-toolchain-r/test

    sudo apt install gcc-${gcc_version} g++-${gcc_version}

    # update alternative - warning, it will this version of gcc as the prioritized version on your system
    
    update-alternatives --install /usr/bin/g++ g++ /usr/bin/g++-${gcc_version} 90
    update-alternatives --install /usr/bin/gcc gcc /usr/bin/gcc-${gcc_version} 90
}

# endregion

# region cmake

function install_cmake {
    cmake_version=3.15.4
    echo "Installing Cmake ${cmake_version}"
    echo
    
    curl -o cmake-${cmake_version}.tar.gz -SL https://github.com/Kitware/CMake/releases/download/v${cmake_version}/cmake-${cmake_version}.tar.gz
    tar -xzf cmake-${cmake_version}.tar.gz
    cd cmake-${cmake_version}
    
    cmake .
    make
    make install
}

# endregion

update_apt

declare -a installers=(
    install_base_deps
    install_gcc
    install_cmake
)

for install in "${installers[@]}"
do
    pushd ${install_path} > /dev/null
    ${install}
    popd > /dev/null
done