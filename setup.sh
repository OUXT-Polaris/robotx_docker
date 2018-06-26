# On EC2 GPU instance
# For Deep Learning Base AMI (Ubuntu) Version 6.0 (ami-ce3673b6)

# install docker-ce
sudo apt-get update
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt-get install docker-ce -y
#sudo groupadd docker　：already exists
sudo usermod -aG docker ubuntu

# install nvidia-docker v2
curl -s -L https://nvidia.github.io/nvidia-docker/gpgkey |  sudo apt-key add -
distribution=$(. /etc/os-release;echo $ID$VERSION_ID)
curl -s -L https://nvidia.github.io/nvidia-docker/$distribution/nvidia-docker.list | \
  sudo tee /etc/apt/sources.list.d/nvidia-docker.list
sudo apt-get update
sudo apt-get install nvidia-docker2 -y

sudo reboot
#sudo pkill -SIGHUP dockerd
sudo systemctl start docker

# build&run docker image
git clone https://github.com/OUXT-Polaris/robotx_docker.git
cd robotx_docker
docker build -t ouxt/robotx .
docker run --runtime=nvidia --rm ouxt/robotx nvidia-smi

# for VN through SSH

# on different terminal
# ssh -i ~/.ssh/ouxt-dev.pem ubuntu@ec2-54-187-105-131.us-west-2.compute.amazonaws.com
