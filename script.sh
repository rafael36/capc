wget https://raw.githubusercontent.com/rafael36/capc/refs/heads/main/dockerfile

wget https://raw.githubusercontent.com/rafael36/capc/refs/heads/main/start.sh

chmod +x start.sh

docker build -t meu-debian-gui .

docker run -it --net=host --cap-add SYS_ADMIN --device /dev/fuse --security-opt apparmor:unconfined meu-debian-gui
