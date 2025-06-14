FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y --no-install-recommends \
  xdotool tmux xvfb fluxbox x11vnc \
  cabextract wget xz-utils ffmpeg \
  libgl1 libvulkan1 mesa-vulkan-drivers mesa-utils \
  libgl1-mesa-dri libglapi-mesa \
  mesa-va-drivers mesa-vulkan-drivers \
  xserver-xorg-video-all va-driver-all vdpau-driver-all \
  libdrm-amdgpu1 libdrm-intel1 libdrm-nouveau2 libdrm-radeon1 \
  curl gpg gnupg2 nano xclip firefox-esr \
  python3 python3-pip python3.11-venv python3-tk python3-dev \
  sudo fuse3 unzip \
  && rm -rf /var/lib/apt/lists/*

RUN dpkg --add-architecture i386

RUN mkdir -pm755 /etc/apt/keyrings && \
  curl -fsSL https://dl.winehq.org/wine-builds/winehq.key | gpg --dearmor -o /etc/apt/keyrings/winehq-archive.gpg

RUN echo "deb [signed-by=/etc/apt/keyrings/winehq-archive.gpg] https://dl.winehq.org/wine-builds/debian bookworm main" \
  > /etc/apt/sources.list.d/winehq.list

RUN apt-get update && apt-get install -y --install-recommends winehq-staging && rm -rf /var/lib/apt/lists/*

# Instala o winetricks
RUN wget https://raw.githubusercontent.com/Winetricks/winetricks/master/src/winetricks && \
    chmod +x winetricks && \
    mv winetricks /usr/local/bin/

RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"



WORKDIR /root


# Instala gdown e baixa o CapCut
RUN pip install gdown && \
    gdown -c --fuzzy https://drive.google.com/file/d/13jp3YTV5Ba_2nlggLxxViUZcump3tmIT/view?usp=sharing && \
    tar -xJf CapCut.tar.xz && \
    rm CapCut.tar.xz


# Copia o script start.sh para o container
COPY start.sh /start.sh
RUN chmod +x /start.sh

# Comando padrão ao iniciar o container: executa start.sh
CMD ["/start.sh"]

