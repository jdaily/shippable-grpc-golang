#!/bin/bash
export DEBIAN_FRONTEND=noninteractive

dpkg-divert --local --rename --add /sbin/initctl
locale-gen en_US en_US.UTF-8
dpkg-reconfigure locales

echo "HOME=$HOME"
cd /u16

echo "================= Adding some global settings ==================="
mv gbl_env.sh /etc/profile.d/
mkdir -p "$HOME/.ssh/"
touch "$HOME/.ssh/known_hosts"

echo "================= Adding packages for shippable_service =================="
apt-get update && apt-get install -y \
    build-essential \
    curl \
    gcc \
    gettext \
    htop \
    libxml2-dev \
    libxslt-dev \
    make \
    nano \
    openssh-client \
    openssl \
    software-properties-common \
    sudo  \
    texinfo \
    unzip \
    wget \
    netcat \
    autotools-dev \
    autoconf \
    bison \
    git \
    mercurial \
    cmake \
    scons \
    binutils \
    bzr \

sudo chmod 1777 /tmp

echo "================= Adding gcloud ============"
CLOUD_SDK_REPO="cloud-sdk-xenial"
echo "deb http://packages.cloud.google.com/apt $CLOUD_SDK_REPO main" | tee /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    
apt-get update && apt-get install -y google-cloud-sdk

# Install Go 1.8
echo "================= Install Go 1.8 ==================="
export  CGO_ENABLED=0

curl -s https://storage.googleapis.com/golang/go1.8.linux-amd64.tar.gz | tar zxvf - -C /usr/local
#echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.bashrc
echo 'export PATH=$PATH:/usr/local/go/bin' >> $HOME/.bashrc

# Really stupid dumb hack for stupid docker "sh" only
ln -s /usr/local/go/bin/go /usr/bin/go

# Install shippable stuffs

echo "================= Adding kubectl 1.5.1 ==================="
curl -sSLO https://storage.googleapis.com/kubernetes-release/release/v1.5.1/bin/linux/amd64/kubectl
chmod +x ./kubectl
sudo mv ./kubectl /usr/local/bin/kubectl


echo "================= Adding jfrog-cli 1.7.0 ==================="
wget -nv https://api.bintray.com/content/jfrog/jfrog-cli-go/1.7.0/jfrog-cli-linux-amd64/jfrog?bt_package=jfrog-cli-linux-amd64 -O jfrog
sudo chmod +x jfrog
mv jfrog /usr/bin/jfrog

echo "================ Adding terraform-0.8.7===================="
export TF_VERSION=0.8.7
export TF_FILE=terraform_"$TF_VERSION"_linux_amd64.zip

echo "Fetching terraform"
echo "-----------------------------------"
rm -rf /tmp/terraform
mkdir -p /tmp/terraform
wget -nv https://releases.hashicorp.com/terraform/$TF_VERSION/$TF_FILE
unzip -o $TF_FILE -d /tmp/terraform
sudo chmod +x /tmp/terraform/terraform
mv /tmp/terraform/terraform /usr/bin/terraform

echo "Added terraform successfully"
echo "-----------------------------------"

echo "================ Adding packer 0.12.2 ===================="
export PK_VERSION=0.12.2
export PK_FILE=packer_"$PK_VERSION"_linux_amd64.zip

echo "Fetching packer"
echo "-----------------------------------"
rm -rf /tmp/packer
mkdir -p /tmp/packer
wget -nv https://releases.hashicorp.com/packer/$PK_VERSION/$PK_FILE
unzip -o $PK_FILE -d /tmp/packer
sudo chmod +x /tmp/packer/packer
mv /tmp/packer/packer /usr/bin/packer

echo "Added packer successfully"
echo "-----------------------------------"

echo "================= Intalling Shippable CLIs ================="
echo "Installing shippable_decrypt"
cp /u16/shippable_decrypt /usr/local/bin/shippable_decrypt

echo "Installing shippable_retry"
cp /u16/shippable_retry /usr/local/bin/shippable_retry

echo "Installing shippable_replace"
cp /u16/shippable_replace /usr/local/bin/shippable_replace

echo "Installed Shippable CLIs successfully"
echo "-------------------------------------"

echo "================= Cleaning package lists ==================="
apt-get clean
apt-get autoclean
apt-get autoremove