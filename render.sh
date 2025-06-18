#!/bin/bash

idiomas=("alemao" "coreano" "espanhol" "frances" "grego" "hindi" "indonesio" "ingles" "italiano" "japones" "mandarim" "polones" "portugues" "romeno" "russo" "tailandes" "turco" "ucraniano" "urdu" "vietnamita")

while true; do
  clear
  echo "==============================="
  echo "    Renderizar vídeos FFmpeg   "
  echo "==============================="
  echo "1 - Escolher 1 ou mais idiomas"
  echo "2 - Escolher 1 idioma"
  echo "3 - Renderizar todos"
  echo "0 - Sair"
  echo "==============================="
  read -rp "Escolha uma opção: " opcao

  case $opcao in
  1)
    clear
    echo "====== Escolha os idiomas ======"
    for i in "${!idiomas[@]}"; do
      printf "%2d - %s\n" "$((i + 1))" "${idiomas[$i]}"
    done
    echo "Exemplo: 1 5 7 10"
    echo "==============================="
    read -rp "Digite os números dos idiomas separados por espaço: " -a escolhas

    for escolha in "${escolhas[@]}"; do
      if [[ "$escolha" =~ ^[0-9]+$ && "$escolha" -gt 0 && "$escolha" -le ${#idiomas[@]} ]]; then
        idioma="${idiomas[$((escolha - 1))]}"
        echo "Executando ./${idioma}.sh..."
        ./"${idioma}.sh"
      else
        echo "Número inválido: $escolha"
      fi
    done
    ;;
  2)
    clear
    echo "====== Escolha o idioma ======"
    for i in "${!idiomas[@]}"; do
      printf "%2d - %s\n" "$((i + 1))" "${idiomas[$i]}"
    done
    echo "0 - Voltar"
    echo "==============================="
    read -rp "Digite o número do idioma: " escolha

    if [[ "$escolha" =~ ^[0-9]+$ && "$escolha" -gt 0 && "$escolha" -le ${#idiomas[@]} ]]; then
      idioma="${idiomas[$((escolha - 1))]}"
      echo "Executando ./${idioma}.sh..."
      ./"${idioma}.sh"
    elif [[ "$escolha" == "0" ]]; then
      continue
    else
      echo "Número inválido!"
    fi
    ;;
  3)
    clear
    echo "Renderizando todos..."
    for idioma in "${idiomas[@]}"; do
      ./"${idioma}.sh"
    done
    ;;
  0)
    echo "Saindo..."
    break
    ;;
  *)
    echo "Opção inválida."
    ;;
  esac

  echo
  read -rp "Pressione ENTER para continuar..."
done
