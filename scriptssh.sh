#!/bin/bash

# Verifica root
[[ "$(id -u)" != "0" ]] && {
  echo -e "\n\033[1;31m[ERRO]\033[0m Execute como root!"
  exit 1
}

# Atualização e instalação de pacotes essenciais
echo -e "\033[1;34m[*] Instalando dependências básicas...\033[0m"
apt update -y && apt upgrade -y
apt install -y curl wget net-tools ufw figlet lsof jq python3 python3-pip nload unzip screen

# Instala stunnel4 se não tiver
if ! command -v stunnel4 &>/dev/null; then
  echo -e "\n\033[1;34m[*] Instalando stunnel4...\033[0m"
  apt install -y stunnel4
  cat >/etc/stunnel/stunnel.conf <<EOF
pid = /var/run/stunnel4.pid
setuid = stunnel4
setgid = stunnel4
client = no
[ssh]
accept = 443
connect = 22
EOF
  echo "ENABLED=1" >/etc/default/stunnel4
  systemctl restart stunnel4
  systemctl enable stunnel4
fi

# Instala squid se quiser
read -p "Deseja instalar proxy Squid na porta 8080? [s/N]: " squid
if [[ "$squid" =~ ^[sS]$ ]]; then
  apt install -y squid
  cat >/etc/squid/squid.conf <<EOF
http_port 8080
http_access allow all
EOF
  systemctl restart squid
  systemctl enable squid
fi

# Criando script menu
cat >/usr/local/bin/menu <<'EOF'
#!/bin/bash

criar_payload() {
  echo -e "\n\033[1;33mGerando payload customizada...\033[0m"
  read -p "Host: " host
  read -p "User-Agent (opcional): " ua
  echo -e "\n\033[1;32mPayload:\033[0m"
  echo -e "GET / HTTP/1.1"
  echo -e "Host: $host"
  [[ -n "$ua" ]] && echo -e "User-Agent: $ua"
  echo -e "Connection: Keep-Alive"
  echo
}

criar_usuario() {
  read -p "Usuário: " user
  read -p "Senha: " senha
  read -p "Dias válidos: " dias
  useradd -M -s /bin/false "$user"
  echo "$user:$senha" | chpasswd
  chage -E $(date -d "$dias days" +%F) "$user"
  echo -e "\n\033[1;32mUsuário criado com sucesso!\033[0m"
}

listar_usuarios() {
  echo -e "\n\033[1;34mUsuários ativos (SSHD):\033[0m"
  lsof -i :22 | grep sshd | grep ESTABLISHED
}

reiniciar_servicos() {
  echo -e "\n\033[1;34mReiniciando serviços...\033[0m"
  systemctl restart ssh
  systemctl restart stunnel4
  [[ -f /usr/sbin/squid ]] && systemctl restart squid
  echo -e "\n\033[1;32mTudo reiniciado!\033[0m"
}

mostrar_menu() {
  clear
  figlet -c MENU SSH+
  echo -e "\033[1;33m==============================\033[0m"
  echo "1 - Criar Payload"
  echo "2 - Criar Usuário SSH"
  echo "3 - Ver Conexões Ativas"
  echo "4 - Reiniciar Serviços"
  echo "0 - Sair"
  echo -e "\033[1;33m==============================\033[0m"
}

while true; do
  mostrar_menu
  read -p "Escolha: " op
  case $op in
    1) criar_payload ;;
    2) criar_usuario ;;
    3) listar_usuarios ;;
    4) reiniciar_servicos ;;
    0) exit ;;
    *) echo -e "\n\033[1;31mOpção inválida\033[0m" ;;
  esac
  echo -e "\nPressione ENTER para continuar..."
  read
done
EOF

chmod +x /usr/local/bin/menu

echo -e "\n\033[1;32mInstalação concluída! Use o comando: \033[1;33mmenu\033[0m"
