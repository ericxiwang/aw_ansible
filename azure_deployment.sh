#!/bin/bash

echo "azure deployment scripts"

echo "===== step 1 install cuda ====="
apt-get install git wget curl unzip
dpkg -i cuda-repo-ubuntu1404-8-0-local-ga2_8.0.61-1_amd64.deb
apt-get update
apt-get install -y cuda
cp cuda.sh /etc/profile.d/.
chmod a+x /etc/profile.d/cuda.sh
source /etc/profile.d/cuda.sh
echo "===== step 2 install cudnn ====="
cp cudnn-8.0-linux-x64-v5.1.tgz /opt/
tar -xvf /opt/cudnn-8.0-linux-x64-v5.1.tgz
cp -P /opt/cuda/include/cudnn.h /usr/include/
cp -P /opt/cuda/lib64/libcudnn* /usr/lib/x86_64-linux-gnu/.
chmod a+r /usr/lib/x86_64-linux-gnu/libcudnn*


echo "===== step 3 install opencv 3.2"

sudo apt-get update
sudo apt-get install -y build-essential
sudo apt-get install -y cmake
sudo apt-get install -y libgtk2.0-dev
sudo apt-get install -y pkg-config
sudo apt-get install -y python-numpy python-dev
sudo apt-get install -y libavcodec-dev libavformat-dev libswscale-dev
sudo apt-get install -y libjpeg-dev libpng-dev libtiff-dev libjasper-dev


apt-get -qq install libopencv-dev build-essential checkinstall cmake pkg-config yasm libjpeg-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libdc1394-22-dev libxine-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev python-dev python-numpy libtbb-dev qt5-default qtbase5-dev qtcore5-dev qtdeclarative5-dev libgtk2.0-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils

apt-get -y install libopencv-dev build-essential cmake libgtk2.0-dev pkg-config python-dev python-numpy libdc1394-22 libdc1394-22-dev libjpeg-dev libpng12-dev libjasper-dev libavcodec-dev libavformat-dev libswscale-dev libgstreamer0.10-dev libgstreamer-plugins-base0.10-dev libv4l-dev libtbb-dev libqt4-dev libfaac-dev libmp3lame-dev libopencore-amrnb-dev libopencore-amrwb-dev libtheora-dev libvorbis-dev libxvidcore-dev x264 v4l-utils



cd /opt
git clone https://github.com/opencv/opencv.git
#git clone https://github.com/opencv/opencv_contrib.git
cd opencv
git checkout 3.3.0

mkdir build
cd build
cmake -G "Unix Makefiles" -D CMAKE_CXX_COMPILER=/usr/bin/g++ CMAKE_C_COMPILER=/usr/bin/gcc -D CMAKE_BUILD_TYPE=RELEASE -D CMAKE_INSTALL_PREFIX=/usr/local -D WITH_TBB=ON -D BUILD_NEW_PYTHON_SUPPORT=ON -D WITH_V4L=ON -D WITH_FFMPEG=ON -D INSTALL_C_EXAMPLES=ON -D INSTALL_PYTHON_EXAMPLES=ON -D BUILD_EXAMPLES=ON -D WITH_QT=ON -D WITH_OPENGL=ON -D BUILD_FAT_JAVA_LIB=ON -D INSTALL_TO_MANGLED_PATHS=ON -D INSTALL_CREATE_DISTRIB=ON -D INSTALL_TESTS=ON -D ENABLE_FAST_MATH=ON -D WITH_IMAGEIO=ON -D BUILD_SHARED_LIBS=OFF -D WITH_GSTREAMER=ON -D WITH_CUDA=OFF ..







make -j$(nproc)

make install

sh -c 'echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf'

ldconfig


echo "===== step 4 install tensorflow ====="

apt-get install libcupti-dev

apt-get install python-pip python-dev python-virtualenv

virtualenv --system-site-packages /virenv


source /virenv/bin/activate

easy_install -U pip

pip install --upgrade tensorflow

#pip install --upgrade tensorflow-gpu


source /virenv/bin/activate



echo "===== step 5 install nginx ====="
apt-get install libssl-dev
tar -xvf nginx-1.12.1.tar.gz

mv nginx-rtmp-module-master.zip nginx-1.12.1/


cd nginx-1.12.1
unzip nginx-rtmp-module-master.zip

./configure --prefix=/usr/local/nginx --add-module=/opt/nginx-1.12.1/nginx-rtmp-module-master --with-http_ssl_module
make
make install
cd ..
#cp nginx.conf /etc/init/
#initctl reload-configuration



echo "===== step 6 install mysql ====="
dpkg -i mysql-apt-config_0.8.8-1_all.deb
apt-get update
apt-get install -y mysql-server
mysql -uroot < init_db.sql


echo "===== step 7 install jdk ====="
add-apt-repository ppa:webupd8team/java
apt-get update
apt-get install oracle-java8-installer


echo "=====  step 8 create all needed folders ====="

mkdir -p /data/images/uploaded
mkdir -p /data/images/camera
mkdir -p /data/images/captioned
mkdir -p /data/images/detected
mkdir -p /data/videos/camera
mkdir -p /data/videos/uploaded
mkdir -p /data/videos/captioned
mkdir -p /data/videos/searched
mkdir -p /data/models
mkdir -p /data/sw
mkdir -p /preserve

echo "===== step 9 copy all models to /data/models"

cp models/*.pb /data/modles/.

echo "===== step 10 create front end folders ====="

mkdir -p /usr/share/nginx/html
cp nginx_conf/nginx.conf /usr/local/nginx/conf/.

echo "===== step 11 copy dist and server to target path"

#unzip server-1.0-SNAPSHOT.zip

#tar -xvf dist.tar.gz -C /usr/share/nginx/html/.
