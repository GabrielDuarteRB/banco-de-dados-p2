#!/bin/bash

# Diretório onde as chaves serão salvas
SSH_DIR="./ssh"
mkdir -p "$SSH_DIR"

# Gera as chaves SSH
ssh-keygen -b 4096 -t rsa -N '' -f "$SSH_DIR/id_rsa"

# Exibe uma mensagem de sucesso
echo "Chaves SSH geradas em: $SSH_DIR"