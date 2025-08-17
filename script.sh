# 1. Rodar o daemon do tailscale (tailscaled) em background
docker run -d --name tailscaled --net=host --privileged tailscale/tailscale tailscaled

# 2. Conectar o tailscale com sua auth key (vai registrar o container na sua rede)
docker exec tailscaled tailscale up --authkey=tskey-auth-kt9aVj9SpY11CNTRL-93H6hNrn4NYhUS7amScvNYHPqCzNLCWe --hostname=docker-tailscale



wget https://raw.githubusercontent.com/rafael36/capc/refs/heads/main/dockerfile

wget https://raw.githubusercontent.com/rafael36/capc/refs/heads/main/start.sh

chmod +x start.sh

docker build -t meu-debian-gui .

docker run -it --net=host --cap-add SYS_ADMIN --device /dev/fuse --security-opt apparmor:unconfined meu-debian-gui
