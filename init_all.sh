#!/bash/bin
set -x

echo "===== update apt-get repo ====="

apt-get -y update
apt-get install -y unzip vim openssh-server

echo "===== enable root ssh login====="

sed -i 's/without-password/yes/g' /etc/ssh/sshd_config
service ssh restart

echo "install git"

apt-get install -y git

echo "install java"

add-apt-repository ppa:webupd8team/java
apt-get update
apt-get install oracle-java8-installer


echo "======install gradle====="

cp gradle-3.2-bin.zip /opt/.
unzip /opt/gradle-3.2-bin.zip
ln -s /opt/gradle-3.2/bin/gradle /usr/bin/gradle


echo "=====install mysql====="
dpkg -i mysql-apt-config_0.8.8-1_all.deb
apt-get update
apt-get install -y mysql-server

mysql -uroot < init_db.sql

echo "=====install nginx====="
cd nginx-1.12.1
./configure --prefix=/usr/local/nginx --add-module=/opt/nginx-1.12.1/nginx-rtmp-module-master --with-http_ssl_module

make
make insall
cd ..

cp nginx.conf /etc/init/
initctl reload-configuration


echo "===== install thrift ====="

apt-get install ant
apt-get install libboost-dev libboost-test-dev libboost-program-options-dev libboost-filesystem-dev libboost-thread-dev libevent-dev automake libtool flex bison pkg-config g++ libssl-dev

cd thrift-0.9.3
./bootstarp.sh
./configure
make
make install


echo "===== install cuda ====="
dpkg -i cuda-repo-ubuntu1404-8-0-local-ga2_8.0.61-1_amd64.deb
apt-get update
apt-get install -y cuda

echo "===== install cudnn ====="
cp cudnn-8.0-linux-x64-v5.1.tgz /opt/
unzip /opt/cudnn-8.0-linux-x64-v5.1.tgz
cp -P /opt/cuda/include/cudnn.h /usr/include/
cp -P /opt/cuda/lib64/libcudnn* /usr/lib/x86_64-linux-gnu/libcudnn*
chmod a+r /usr/lib/x86_64-linux-gnu/libcudnn*


echo "===== install opencv ====="
cd /opt
https://github.com/opencv/opencv.git
cd opencv
git checkout 3.3.0 
mkdir build
cd build
cmake -D CMAKE_BUILD_TYPE=RELEASE \
      -D CMAKE_INSTALL_PREFIX=/usr/local \
      -D INSTALL_C_EXAMPLES=ON \
      -D INSTALL_PYTHON_EXAMPLES=ON \
      -D WITH_TBB=ON \
      -D WITH_V4L=ON \
      -D WITH_QT=ON \
      -D WITH_OPENGL=ON \
      -D OPENCV_EXTRA_MODULES_PATH=../../opencv_contrib/modules \
      -D BUILD_EXAMPLES=ON ..

make -j4

make install

sh -c 'echo "/usr/local/lib" >> /etc/ld.so.conf.d/opencv.conf'

ldconfig

echo "===== install dependencies for opencv ====="

apt-get install libtbb-dev
apt-get install libtbb2
apt-get install openexr
apt-get install libdc1394-22


echo "===== install tensorflow ====="

apt-get install libcupti-dev

apt-get install python-pip python-dev python-virtualenv

virtualenv --system-site-packages /virenv


source /virenv/bin/activate

easy_install -U pip

pip install --upgrade tensorflow

pip install --upgrade tensorflow-gpu


source /virenv/bin/activate







echo "===== install ffmpeg ====="


echo "===== create project folder ===="

mkdir -p /data/images/uploaded
mkdir -p /data/images/camera
mkdir -p /data/images/captioned
mkdir -p /data/images/detected
mkdir -p /data/videos/camera
mkdir -p /data/videos/uploaded
mkdir -p /data/videos/captioned
mkdir -p /data/videos/searched
mkdir -p /data/models
mkdir -p /preserve



echo "===== check all dependencies version ====="
java -version  #1.8.0_144
thrift -version  #0.9.3
gradle -version   #3.2
/usr/local/nginx/sbin/nginx -v # 1.12.1
mysql --version  #5.7.19



