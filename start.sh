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

tail -f /dev/null
