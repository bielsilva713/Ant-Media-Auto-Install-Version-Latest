#!/bin/bash

# Função para exibir o menu de seleção de idioma
selecionar_idioma() {
    echo "Selecione o idioma / Select the language:"
    echo "1) Português"
    echo "2) English"
    read -p "Escolha uma opção / Choose an option: " idioma
}

# Função para definir mensagens com base na seleção do idioma
definir_mensagens() {
    case $idioma in
        1)
            MSG_PASSO_1="✅ PASSO 1: Atualizando os repositórios do apt..."
            MSG_PASSO_2="✅ PASSO 2: Baixando a última versão do Ant Media Server..."
            MSG_PASSO_3="✅ PASSO 3: Baixando o script de instalação do Ant Media Server..."
            MSG_PASSO_4="✅ PASSO 4: Concedendo permissões de execução ao script..."
            MSG_PASSO_5="✅ PASSO 5: Listando diretório atual..."
            MSG_PASSO_6="✅ PASSO 6: Copie o texto vermelho e cole-o após o comando abaixo:"
            MSG_PASSO_7="✅ PASSO 7: Configurando as regras do iptables..."
            MSG_PASSO_8="✅ PASSO 8: Configurando as configurações adicionais de rede..."
            MSG_ENDERECO="➜ O endereço de login para acessar o Ant Media Server é:"
            MSG_COLE_AQUI="COLE AQUI"
            MSG_PERGUNTA_INSTALACAO="Deseja instalar o Ant Media Server? (s/n)"
            MSG_INSTALACAO_CONFIRMADA="Ant Media Server será instalado."
            MSG_INSTALACAO_CANCELADA="Instalação cancelada."
            ;;
        2)
            MSG_PASSO_1="✅ STEP 1: Updating apt repositories..."
            MSG_PASSO_2="✅ STEP 2: Downloading the latest version of Ant Media Server..."
            MSG_PASSO_3="✅ STEP 3: Downloading the Ant Media Server installation script..."
            MSG_PASSO_4="✅ STEP 4: Granting execution permissions to the script..."
            MSG_PASSO_5="✅ STEP 5: Listing current directory..."
            MSG_PASSO_6="✅ STEP 6: Copy the red text and paste it after the command below:"
            MSG_PASSO_7="✅ STEP 7: Configuring iptables rules..."
            MSG_PASSO_8="✅ STEP 8: Configuring additional network settings..."
            MSG_ENDERECO="➜ The login address to access Ant Media Server is:"
            MSG_COLE_AQUI="PASTE HERE"
            MSG_PERGUNTA_INSTALACAO="Do you want to install Ant Media Server? (y/n)"
            MSG_INSTALACAO_CONFIRMADA="Ant Media Server will be installed."
            MSG_INSTALACAO_CANCELADA="Installation canceled."
            ;;
        *)
            echo "Opção inválida. / Invalid option. Defaulting to Portuguese."
            definir_mensagens 1
            ;;
    esac
}

# Selecionar idioma
selecionar_idioma

# Definir mensagens com base na seleção do idioma
definir_mensagens

# Perguntar ao usuário se deseja instalar o Ant Media Server
read -p "$MSG_PERGUNTA_INSTALACAO" instalar
if [[ $instalar =~ ^[SsYy]$ ]]; then
    # Passo 1
    echo "$MSG_PASSO_1"
    sudo apt update -y && sudo apt upgrade -y

    # Instalar jq para parsear JSON
    sudo apt-get install jq -y

    # Passo 2
    echo "$MSG_PASSO_2"
    LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/ant-media/Ant-Media-Server/releases/latest | jq -r '.assets[] | select(.name | test(".*.zip$")) | .browser_download_url')
    wget $LATEST_RELEASE_URL

    # Extrair o nome do arquivo da URL
    FILENAME=$(basename $LATEST_RELEASE_URL)

    # Passo 3
    echo "$MSG_PASSO_3"
    wget https://raw.githubusercontent.com/ant-media/Scripts/master/install_ant-media-server.sh

    # Passo 4
    echo "$MSG_PASSO_4"
    chmod 755 install_ant-media-server.sh

    # Passo 5
    echo "$MSG_PASSO_6"
    echo "sudo ./install_ant-media-server.sh -i $FILENAME"

    # Passo 6
    echo "$MSG_PASSO_7"
    iptables -P INPUT ACCEPT && iptables -P OUTPUT ACCEPT && iptables -P FORWARD ACCEPT && iptables -F && iptables -A INPUT -p tcp --dport 1935 -j ACCEPT && iptables -A INPUT -p tcp --dport 5080 -j ACCEPT && iptables -A INPUT -p tcp --dport 5443 -j ACCEPT && iptables -A INPUT -p udp --dport 50000:60000 -j ACCEPT && iptables -A INPUT -p tcp --dport 5000:65000 -j ACCEPT && sudo netfilter-persistent save

    # Passo 7 - Configurações adicionais de rede
    echo "$MSG_PASSO_8"
    echo "net.core.rmem_max = 16777216" | sudo tee -a /etc/sysctl.conf && echo "net.core.wmem_max = 16777216" | sudo tee -a /etc/sysctl.conf && echo "net.ipv4.tcp_rmem = 4096 87380 16777216" | sudo tee -a /etc/sysctl.conf && echo "net.ipv4.tcp_wmem = 4096 87380 16777216" | sudo tee -a /etc/sysctl.conf && echo "net.ipv4.tcp_window_scaling = 1" | sudo tee -a /etc/sysctl.conf && echo "net.ipv4.tcp_mtu_probing = 1" | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

    # Obter o IP público da instância
    IP=$(curl -s ifconfig.me)

    echo ""
    echo "$MSG_ENDERECO http://$IP:5080"
else
    echo "$MSG_INSTALACAO_CANCELADA"
fi
