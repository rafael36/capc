sudo apt install fuse3

sudo usermod -aG fuse $USER

docker run -d --name tailscaled --net=host --privileged tailscale/tailscale tailscaled

docker exec tailscaled tailscale up --auth-key=tskey-auth-k8bCbtUnQ821CNTRL-apiMHUxgRD9c2Z2PuNocC9V9BZPriNZi --hostname=docker-tailscale

wget https://raw.githubusercontent.com/rafael36/capc/refs/heads/main/dockerfile

wget https://raw.githubusercontent.com/rafael36/capc/refs/heads/main/start.sh

wget https://raw.githubusercontent.com/rafael36/capc/refs/heads/main/rclone.conf

chmod +x script.sh

docker build -t meu-debian-gui .

docker run -it --net=host --cap-add SYS_ADMIN --device /dev/fuse --security-opt apparmor:unconfined meu-debian-gui
