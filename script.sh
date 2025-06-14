

docker run -d --name tailscaled --net=host --privileged tailscale/tailscale tailscaled

docker exec tailscaled tailscale up --auth-key=tskey-auth-kHkq3w1QKK11CNTRL-yUuCdJME62gVPjwRES5x2g3iEaUhhDbK --hostname=docker-tailscale

wget https://raw.githubusercontent.com/rafael36/capc/refs/heads/main/dockerfile

wget https://raw.githubusercontent.com/rafael36/capc/refs/heads/main/start.sh

chmod +x script.sh

docker build -t meu-debian-gui .

docker run -it --net=host --cap-add SYS_ADMIN --device /dev/fuse --security-opt apparmor:unconfined meu-debian-gui

docker ps
