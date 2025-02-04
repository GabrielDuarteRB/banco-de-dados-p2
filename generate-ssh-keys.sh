#!/bin/bash

# Diretório onde as chaves serão salvas
SSH_DIR="./ssh"
BARMAN="barman"
POSTGRES="postgres"
mkdir -p "$SSH_DIR"
mkdir -p "$SSH_DIR/$BARMAN"
mkdir -p "$SSH_DIR/$POSTGRES"

# Gera as chaves SSH
ssh-keygen -b 4096 -t rsa -N '' -f "$SSH_DIR/$BARMAN/id_rsa"
ssh-keygen -b 4096 -t rsa -N '' -f "$SSH_DIR/$POSTGRES/id_rsa"

# Exibe uma mensagem de sucesso
echo "Chaves SSH geradas em: $SSH_DIR"