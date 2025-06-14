sudo apt install fuse3

sudo usermod -aG fuse $USER

docker run -d --name tailscaled --net=host --privileged tailscale/tailscale tailscaled

docker exec tailscaled tailscale up --auth-key=tskey-auth-kjxTHZ1LJ511CNTRL-QCeFfX2htzRYFA6h4B4hzRGyLgaP2sMN2 --hostname=docker-tailscale

wget https://raw.githubusercontent.com/rafael36/capc/refs/heads/main/dockerfile

wget https://raw.githubusercontent.com/rafael36/capc/refs/heads/main/start.sh

chmod +x script.sh

docker build -t meu-debian-gui .

docker run -it --net=host --cap-add SYS_ADMIN --device /dev/fuse --security-opt apparmor:unconfined meu-debian-gui
