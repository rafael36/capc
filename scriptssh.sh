#!/bin/bash

# Arquivos base para armazenamento
USERS_DB="$HOME/ssh_users.db"
PAYLOADS_DB="$HOME/ssh_payloads.db"

# Função para criar usuário SSH
create_user() {
    clear
    echo "Criar novo usuário SSH"
    read -rp "Login: " user
    read -rp "Senha: " pass
    read -rp "Dias válidos (0 para sem expiração): " days
    read -rp "Shell (/bin/bash ou /bin/false): " shell

    [[ "$shell" != "/bin/bash" && "$shell" != "/bin/false" ]] && shell="/bin/false"

    # Data expiração em timestamp
    if [[ "$days" =~ ^[0-9]+$ && "$days" -gt 0 ]]; then
        expire_date=$(date -d "+$days days" +"%Y-%m-%d")
    else
        expire_date="never"
    fi

    # Cria usuário no sistema
    if id "$user" &>/dev/null; then
        echo "Usuário já existe!"
    else
        sudo useradd -m -s "$shell" "$user"
        echo "$user:$pass" | sudo chpasswd
        [[ "$expire_date" != "never" ]] && sudo chage -E "$expire_date" "$user"
        echo "Usuário criado com expiração: $expire_date"
        # Salva no banco local
        echo "$user:$expire_date" >> "$USERS_DB"
    fi
    echo "Pressione ENTER para continuar..."
    read
}

# Função para listar usuários SSH criados via script (do arquivo)
list_users() {
    clear
    echo "Usuários SSH criados via script:"
    if [[ -f "$USERS_DB" ]]; then
        printf "%-15s %-15s\n" "Usuário" "Expira em"
        echo "------------------------------------"
        cat "$USERS_DB"
    else
        echo "Nenhum usuário cadastrado."
    fi
    echo ""
    echo "Pressione ENTER para continuar..."
    read
}

# Função para mostrar conexões SSH ativas
active_connections() {
    clear
    echo "Conexões SSH ativas:"
    sudo netstat -tnpa 2>/dev/null | grep sshd | grep ESTABLISHED | awk '{print $7, $5}'
    echo ""
    echo "Pressione ENTER para continuar..."
    read
}

# Função para mostrar portas abertas relevantes
open_ports() {
    clear
    echo "Portas TCP abertas (filtrado):"
    sudo ss -tlnp | grep -E "(:22|:80|:443|:3128|:8080|:8799)"
    echo ""
    echo "Pressione ENTER para continuar..."
    read
}

# Função para criar payload HTTP Injector
create_payload() {
    clear
    echo "Criar novo payload HTTP Injector"
    read -rp "Host: " host
    read -rp "Porta: " port
    read -rp "Path (ex: /path): " path
    read -rp "Headers adicionais (ex: Host: example.com): " headers

    payload="CONNECT $host:$port HTTP/1.1\r\n$headers\r\n\r\n"

    echo -e "$payload"
    echo "$host|$port|$path|$headers" >> "$PAYLOADS_DB"

    echo "Payload salvo."
    echo "Pressione ENTER para continuar..."
    read
}

# Função para listar payloads criados
list_payloads() {
    clear
    echo "Payloads criados:"
    if [[ -f "$PAYLOADS_DB" ]]; then
        nl -w3 -s". " "$PAYLOADS_DB"
    else
        echo "Nenhum payload salvo."
    fi
    echo ""
    echo "Pressione ENTER para continuar..."
    read
}

# Reiniciar serviços
restart_services() {
    clear
    echo "Reiniciando sshd..."
    sudo systemctl restart sshd
    echo "Serviço sshd reiniciado."
    echo "Pressione ENTER para continuar..."
    read
}

# Menu principal
while true; do
    clear
    echo "==============================="
    echo "        Menu SSH Manager        "
    echo "==============================="
    echo "1 - Criar usuário SSH"
    echo "2 - Listar usuários SSH criados"
    echo "3 - Ver conexões SSH ativas"
    echo "4 - Ver portas TCP abertas"
    echo "5 - Criar payload HTTP Injector"
    echo "6 - Listar payloads"
    echo "7 - Reiniciar serviço SSH"
    echo "0 - Sair"
    echo "==============================="
    read -rp "Escolha: " choice

    case $choice in
        1) create_user ;;
        2) list_users ;;
        3) active_connections ;;
        4) open_ports ;;
        5) create_payload ;;
        6) list_payloads ;;
        7) restart_services ;;
        0) exit 0 ;;
        *) echo "Opção inválida." ; sleep 1 ;;
    esac
done
