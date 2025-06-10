apt update && apt upgrade -y && apt autoremove -y && apt clean
apt-get update && apt-get upgrade -y && apt-get autoremove -y && apt-get clean
apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
