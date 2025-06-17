#!/bin/bash

while true; do
    clear
    echo "=============================="
    echo "1 - Criar Payload (não implementado)"
    echo "2 - Criar Usuário SSH"
    echo "3 - Ver Conexões Ativas"
    echo "4 - Reiniciar Serviços SSH"
    echo "0 - Sair"
    echo "=============================="
    echo -n "Escolha: "
    read opcao

    case $opcao in
        1)
            echo "Função criar payload ainda não implementada."
            read -p "Pressione ENTER para continuar..."
            ;;
        2)
            echo -ne "\033[1;36mUsuário: \033[1;37m"
            read usuario
            echo -ne "\033[1;36mSenha: \033[1;37m"
            read -s senha
            echo ""
            echo -ne "\033[1;36mDias válidos: \033[1;37m"
            read dias

            dataexp=$(date -d "+$dias days" +%Y-%m-%d)

            # Cria usuário com shell bash
            if id "$usuario" &>/dev/null; then
                echo "Usuário $usuario já existe."
            else
                useradd -m -s /bin/bash -e "$dataexp" "$usuario"
                echo "$usuario:$senha" | chpasswd
                chage -d 0 "$usuario"
                echo "Usuário $usuario criado com sucesso!"
            fi
            read -p "Pressione ENTER para continuar..."
            ;;
        3)
            echo "Usuários ativos (SSHD):"
            ss -tnp | grep sshd
            read -p "Pressione ENTER para continuar..."
            ;;
        4)
            echo "Reiniciando serviço SSH..."
            systemctl restart sshd
            echo "Serviço SSH reiniciado."
            read -p "Pressione ENTER para continuar..."
            ;;
        0)
            echo "Saindo..."
            exit 0
            ;;
        *)
            echo "Opção inválida!"
            read -p "Pressione ENTER para continuar..."
            ;;
    esac
done
