#!/bin/bash

# Passo 1
echo "✅ PASSO 1: Concedendo permissões de superusuário..."
sudo -i

# Passo 2
echo "✅ PASSO 2: Atualizando os repositórios do apt..."
sudo apt update -y

# Passo 3
echo "✅ PASSO 3: Baixando a última versão do Ant Media Server..."
wget https://github.com/ant-media/Ant-Media-Server/releases/latest

# Passo 4
echo "✅ PASSO 4: Baixando o script de instalação do Ant Media Server..."
wget https://raw.githubusercontent.com/ant-media/Scripts/master/install_ant-media-server.sh

# Passo 5
echo "✅ PASSO 5: Concedendo permissões de execução ao script..."
chmod 755 install_ant-media-server.sh

# Passo 6
echo "✅ PASSO 6: Listando diretório atual..."
ls

# Passo 7
echo "✅ PASSO 7: Copie o texto vermelho e cole-o após o comando abaixo:"
echo "sudo ./install_ant-media-server.sh -i COLE AQUI"

# Passo 8
echo "✅ PASSO 8: Configurando as regras do iptables..."
iptables -P INPUT ACCEPT && iptables -P OUTPUT ACCEPT && iptables -P FORWARD ACCEPT && iptables -F && sudo netfilter-persistent save

# IP da Instância
IP=$(hostname -I | cut -d' ' -f1)

echo ""
echo "➜ O endereço de login para acessar o Ant Media Server é: http://$IP:5080"
