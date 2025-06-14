#!/bin/bash
# start.sh - inicia Xvfb, fluxbox, x11vnc e CapCut via Wine

# Inicia Xvfb no display :1
Xvfb :1 -screen 0 1360x768x24 &
sleep 2
export DISPLAY=:1

# Inicia Fluxbox
fluxbox &
sleep 2

# Inicia x11vnc dentro do tmux (sessão "fee")
tmux new-session -d -s fee
tmux send-keys -t fee 'x11vnc -display :1 -rfbport 5905 -forever -nopw' C-m

# Instala dependências do Wine com winetricks
tmux new-session -d -s fsc
tmux send-keys -t fsc 'winetricks corefonts vcrun2019' C-m

# Aguarda instalação (ajustável conforme o tempo real necessário)
sleep 10

# Simulação de cliques com xdotool para interagir com janelas do winetricks
xdotool mousemove 816 442 click 1
sleep 60
xdotool mousemove 456 464 click 1
sleep 2
xdotool mousemove 786 499 click 1
sleep 10
xdotool mousemove 871 498 click 1
sleep 10
xdotool mousemove 456 464 click 1
sleep 2
xdotool mousemove 786 499 click 1
sleep 10
xdotool mousemove 871 498 click 1
sleep 15

# Executa CapCut com Wine em nova sessão tmux
tmux new-session -d -s fsx
tmux send-keys -t fsx 'wine CapCut/CapCut.exe' C-m

mkdir rclonepasta
mkdir rclonecache

wget https://downloads.rclone.org/v1.69.3/rclone-v1.69.3-linux-amd64.zip

wget https://raw.githubusercontent.com/rafael36/capc/refs/heads/main/rclone.conf

unzip rclone-v1.69.3-linux-amd64.zip

chmod +x rclone-v1.69.3-linux-amd64/rclone

cd rclone-v1.69.3-linux-amd64

./rclone mount mcny7yad@gmail.com:canaisyt /root/rclonepasta \
  --config=/root/rclone.conf \
  --vfs-cache-mode=full \
  --vfs-cache-max-size=100G \
  --cache-dir=/rclonecache \
  --vfs-cache-max-age=24h \
  --vfs-write-back=10s \
  --buffer-size=64M \
  --dir-cache-time=12h \
  --poll-interval=15s \
  --vfs-read-chunk-size=64M \
  --vfs-read-chunk-size-limit=1G \
  --transfers=4 \
  --checkers=8 \
  --tpslimit=4 \
  --drive-chunk-size=64M \
  --log-level=INFO \
  --allow-other \
  --uid=$(id -u) \
  --gid=$(id -g) \
  --umask=002



tail -f /dev/null
