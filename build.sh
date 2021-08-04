#!/bin/bash

sudo apt install -y libgl1-mesa-dev tesseract-ocr libjpeg-dev
sudo apt install -y cmake wget libboost-all-dev ctags build-essential
sudo apt install -y python3-pip python3.6-venv python3.6-dev python3-setuptools
sudo apt install -y llvm-9*
sudo apt install -y libatlas-base-dev gfortran libfreetype6-dev
sudo apt install -y protobuf-compiler libprotobuf-dev openssl libssl-dev libcurl4-openssl-dev
sudo apt install -y libjpeg-dev zlib1g-dev libpython3-dev libavcodec-dev libavformat-dev libswscale-dev
sudo apt install -y libopenblas-base libopenmpi-dev libopenblas-dev

sudo ln -s /usr/bin/llvm-config-9 /usr/bin/llvm-config


python3.6 -m venv --system-site-packages .venv
. .venv/bin/activate

pip install -U pip 
pip install -r requirements.txt
pip wheel -w dist -r requirements.txt

## pycuda
export CUDA_HOME=/usr/local/cuda
export CUDA_INC_DIR=${CUDA_HOME}/include
export PATH=${CUDA_HOME}/bin:${PATH}
export LD_LIBRARY_PATH=${CUDA_HOME}/lib64:${LD_LIBRARY_PATH}

wget  https://files.pythonhosted.org/packages/5a/56/4682a5118a234d15aa1c8768a528aac4858c7b04d2674e18d586d3dfda04/pycuda-2021.1.tar.gz
tar xvf pycuda-2021.1.tar.gz
(
	cd pycude-2021.1;
	./configure.py;
	make -j2;
	python setup.py install;
	python setup.py bdist_wheel;
	cp dist/pycuda-*.whl ../dist/;
)

wget https://nvidia.box.com/shared/static/p57jwntv436lfrd78inwl7iml6p13fzh.whl -O torch-1.8.0-cp36-cp36m-linux_aarch64.whl
pip install torch-1.8.0-cp36-cp36m-linux_aarch64.whl
mv ./torch-1.8.0-cp36-cp36m-linux_aarch64.whl ./dist/

# wget http://www.cmake.org/files/v3.13/cmake-3.13.0.tar.gz
# tar xpvf cmake-3.13.0.tar.gz cmake-3.13.0/
# (
# 	cd cmake-3.13.0/;
# 	./bootstrap --system-curl;
# 	make -j8;
# 	sudo make install;
# )


git clone --branch v0.9.0  https://github.com/pytorch/vision torchvision
(
	cd torchvision;
	export BUILD_VERSION=0.9.0;
	python setup.py install;
	python setup.py bdist_wheel;
	cp dist/*.whl ../dist/;
)


wget https://github.com/scipy/scipy/releases/download/v1.3.3/scipy-1.3.3.tar.gz
tar -xzvf scipy-1.3.3.tar.gz
(
	cd scipy-1.3.3/;
	python3 setup.py install;
	python setup.py bdist_wheel;
	cp dist/*.whl ../dist/;
)

tar cvzf wheels.tgz dist;
