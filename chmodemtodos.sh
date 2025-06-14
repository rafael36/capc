#!/bin/bash

# Lista de arquivos para dar permissão de execução
arquivos=(
  "alemaojunta.sh"
  "coreanojunta.sh"
  "espanholjunta.sh"
  "francesjunta.sh"
  "gregojunta.sh"
  "hindijunta.sh"
  "indonesiojunta.sh"
  "inglesjunta.sh"
  "italianojunta.sh"
  "japonesjunta.sh"
  "polonesjunta.sh"
  "portuguesjunta.sh"
  "romenojunta.sh"
  "russojunta.sh"
  "turcojunta.sh"
)

# Percorre a lista de arquivos e aplica chmod +x em cada um
for arquivo in "${arquivos[@]}"; do
  if [ -f "$arquivo" ]; then
    chmod +x "$arquivo"
    echo "Permissão de execução concedida a: $arquivo"
  else
    echo "Arquivo não encontrado: $arquivo"
  fi
done

echo "Processo concluído."
