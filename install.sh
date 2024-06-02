#!/bin/bash

# Cores
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[0;33m'
NC='\033[0m' # Sem cor

# Função para exibir o menu de seleção de idioma
selecionar_idioma() {
    echo -e "${CYAN}Selecione o idioma / Select the language:${NC}"
    echo -e "${GREEN}1) Português${NC}"
    echo -e "${GREEN}2) English${NC}"
    read -p "Escolha uma opção / Choose an option: " idioma
}

# Função para definir mensagens com base na seleção do idioma
definir_mensagens() {
    case $idioma in
        1)
            MSG_PASSO_1="${GREEN}✅ PASSO 1:${NC} Atualizando os repositórios do apt..."
            MSG_PASSO_2="${GREEN}✅ PASSO 2:${NC} Baixando a última versão do Ant Media Server..."
            MSG_PASSO_3="${GREEN}✅ PASSO 3:${NC} Baixando o script de instalação do Ant Media Server..."
            MSG_PASSO_4="${GREEN}✅ PASSO 4:${NC} Concedendo permissões de execução ao script..."
            MSG_PASSO_5="${GREEN}✅ PASSO 5:${NC} Listando diretório atual..."
            MSG_PASSO_6="${GREEN}✅ PASSO 6:${NC} Copie o texto ${RED}vermelho${NC} e cole-o após o comando abaixo:"
            MSG_PASSO_7="${GREEN}✅ PASSO 7:${NC} Configurando as regras do iptables..."
            MSG_PASSO_8="${GREEN}✅ PASSO 8:${NC} Configurando as configurações adicionais de rede..."
            MSG_ENDERECO="${BLUE}➜ O endereço de login para acessar o Ant Media Server é:${NC}"
            MSG_COLE_AQUI="${RED}COLE AQUI${NC}"
            MSG_PERGUNTA_INSTALACAO="Deseja instalar o Ant Media Server? (s/n)"
            MSG_INSTALACAO_CONFIRMADA="${GREEN}Ant Media Server será instalado.${NC}"
            MSG_INSTALACAO_CANCELADA="${RED}Instalação cancelada.${NC}"
            MSG_VERIFICANDO_SERVICO="${GREEN}Verificando o status do serviço Ant Media Server...${NC}"
            MSG_SERVICO_OK="${GREEN}O serviço Ant Media Server está em execução.${NC}"
            MSG_SERVICO_ERRO="${RED}O serviço Ant Media Server não está em execução.${NC}"
            MSG_VERIFICANDO_PORTAS="${GREEN}Verificando portas e regras de firewall...${NC}"
            MSG_PORTAS_OK="${GREEN}Portas e regras de firewall estão configuradas corretamente.${NC}"
            MSG_PORTAS_ERRO="${RED}Problema com as portas ou regras de firewall.${NC}"
            MSG_VERIFICANDO_LOGS="${GREEN}Verificando logs do Ant Media Server para erros...${NC}"
            MSG_LOGS_ERRO="${RED}Erros encontrados nos logs do Ant Media Server.${NC}"
            MSG_LOGS_OK="${GREEN}Nenhum erro encontrado nos logs do Ant Media Server.${NC}"
            ;;
        2)
            MSG_PASSO_1="${GREEN}✅ STEP 1:${NC} Updating apt repositories..."
            MSG_PASSO_2="${GREEN}✅ STEP 2:${NC} Downloading the latest version of Ant Media Server..."
            MSG_PASSO_3="${GREEN}✅ STEP 3:${NC} Downloading the Ant Media Server installation script..."
            MSG_PASSO_4="${GREEN}✅ STEP 4:${NC} Granting execution permissions to the script..."
            MSG_PASSO_5="${GREEN}✅ STEP 5:${NC} Listing current directory..."
            MSG_PASSO_6="${GREEN}✅ STEP 6:${NC} Copy the ${RED}red${NC} text and paste it after the command below:"
            MSG_PASSO_7="${GREEN}✅ STEP 7:${NC} Configuring iptables rules..."
            MSG_PASSO_8="${GREEN}✅ STEP 8:${NC} Configuring additional network settings..."
            MSG_ENDERECO="${BLUE}➜ The login address to access Ant Media Server is:${NC}"
            MSG_COLE_AQUI="${RED}PASTE HERE${NC}"
            MSG_PERGUNTA_INSTALACAO="Do you want to install Ant Media Server? (y/n)"
            MSG_INSTALACAO_CONFIRMADA="${GREEN}Ant Media Server will be installed.${NC}"
            MSG_INSTALACAO_CANCELADA="${RED}Installation canceled.${NC}"
            MSG_VERIFICANDO_SERVICO="${GREEN}Checking the status of the Ant Media Server service...${NC}"
            MSG_SERVICO_OK="${GREEN}Ant Media Server service is running.${NC}"
            MSG_SERVICO_ERRO="${RED}Ant Media Server service is not running.${NC}"
            MSG_VERIFICANDO_PORTAS="${GREEN}Checking ports and firewall rules...${NC}"
            MSG_PORTAS_OK="${GREEN}Ports and firewall rules are configured correctly.${NC}"
            MSG_PORTAS_ERRO="${RED}Problem with ports or firewall rules.${NC}"
            MSG_VERIFICANDO_LOGS="${GREEN}Checking Ant Media Server logs for errors...${NC}"
            MSG_LOGS_ERRO="${RED}Errors found in the Ant Media Server logs.${NC}"
            MSG_LOGS_OK="${GREEN}No errors found in the Ant Media Server logs.${NC}"
            ;;
        *)
            echo -e "${RED}Opção inválida. / Invalid option. Defaulting to Portuguese.${NC}"
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
    echo -e "$MSG_PASSO_1"
    sudo apt update -y && sudo apt upgrade -y

    # Instalar jq para parsear JSON
    sudo apt-get install jq -y

    # Passo 2
    echo -e "$MSG_PASSO_2"
    LATEST_RELEASE_URL=$(curl -s https://api.github.com/repos/ant-media/Ant-Media-Server/releases/latest | jq -r '.assets[] | select(.name | test(".*.zip$")) | .browser_download_url')
    wget $LATEST_RELEASE_URL

    # Extrair o nome do arquivo da URL
    FILENAME=$(basename $LATEST_RELEASE_URL)

    # Passo 3
    echo -e "$MSG_PASSO_3"
    wget https://raw.githubusercontent.com/ant-media/Scripts/master/install_ant-media-server.sh

    # Passo 4
    echo -e "$MSG_PASSO_4"
    chmod 755 install_ant-media-server.sh

    # Passo 5
    echo -e "$MSG_PASSO_6"
    echo "sudo ./install_ant-media-server.sh -i $FILENAME"

    # Passo 6
    echo -e "$MSG_PASSO_7"
    iptables -P INPUT ACCEPT && iptables -P OUTPUT ACCEPT && iptables -P FORWARD ACCEPT && iptables -F && iptables -A INPUT -p tcp --dport 1935 -j ACCEPT && iptables -A INPUT -p tcp --dport 5080 -j ACCEPT && iptables -A INPUT -p tcp --dport 5443 -j ACCEPT && iptables -A INPUT -p udp --dport 50000:60000 -j ACCEPT && iptables -A INPUT -p tcp --dport 5000:65000 -j ACCEPT && sudo netfilter-persistent save

    # Passo 7 - Configurações adicionais de rede
    echo -e "$MSG_PASSO_8"
    echo "net.core.rmem_max = 16777216" | sudo tee -a /etc/sysctl.conf && echo "net.core.wmem_max = 16777216" | sudo tee -a /etc/sysctl.conf && echo "net.ipv4.tcp_rmem = 4096 87380 16777216" | sudo tee -a /etc/sysctl.conf && echo "net.ipv4.tcp_wmem = 4096 87380 16777216" | sudo tee -a /etc/sysctl.conf && echo "net.ipv4.tcp_window_scaling = 1" | sudo tee -a /etc/sysctl.conf && echo "net.ipv4.tcp_mtu_probing = 1" | sudo tee -a /etc/sysctl.conf && sudo sysctl -p

    # Verificar se o serviço do Ant Media Server está em execução
    echo -e "$MSG_VERIFICANDO_SERVICO"
    if systemctl is-active --quiet antmedia; then
        echo -e "$MSG_SERVICO_OK"
    else
        echo -e "$MSG_SERVICO_ERRO"
        echo -e "${YELLOW}Tentando reiniciar o serviço...${NC}"
        sudo systemctl restart antmedia
        if systemctl is-active --quiet antmedia; then
            echo -e "$MSG_SERVICO_OK"
        else
            echo -e "$MSG_SERVICO_ERRO"
            exit 1
        fi
    fi

    # Verificar se as portas estão abertas e as regras do firewall estão corretas
    echo -e "$MSG_VERIFICANDO_PORTAS"
    PORTS=(1935 5080 5443 50000:60000 5000:65000)
    for PORT in "${PORTS[@]}"; do
        if ! sudo iptables -L -n | grep -q "$PORT"; then
            echo -e "$MSG_PORTAS_ERRO"
            exit 1
        fi
    done
    echo -e "$MSG_PORTAS_OK"

    # Verificar logs do Ant Media Server
    echo -e "$MSG_VERIFICANDO_LOGS"
    if sudo grep -i "error" /var/log/antmedia/antmedia-error.log; then
        echo -e "$MSG_LOGS_ERRO"
        exit 1
    else
        echo -e "$MSG_LOGS_OK"
    fi

    # Obter o IP público da instância
    IP=$(curl -s ifconfig.me)

    echo ""
    echo -e "$MSG_ENDERECO ${YELLOW}http://$IP:5080${NC}"
else
    echo -e "$MSG_INSTALACAO_CANCELADA"
fi
