docker exec tailscaled tailscale up --authkey=tskey-auth-kt9aVj9SpY11CNTRL-93H6hNrn4NYhUS7amScvNYHPqCzNLCWe --hostname=docker-tailscale

wget https://raw.githubusercontent.com/rafael36/capc/refs/heads/main/dockerfile

wget https://raw.githubusercontent.com/rafael36/capc/refs/heads/main/start.sh

chmod +x script.sh

docker build -t meu-debian-gui .

docker run -it --net=host meu-debian-gui
