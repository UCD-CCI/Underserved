#!/bin/bash

#-----------------------------------------------------------------------------------------------------------------------
# SCRIPT THEME
#-----------------------------------------------------------------------------------------------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'
WHITE='\033[0;37m'


divider() {
    echo -e "${GREEN}===============================================================================================${NC}"
}

section_header() {
    local message="$1"
    divider
    echo -e "${CYAN}$message${NC}"
    divider
}
#-----------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------
# SCRIPT BANNER AND STARTING POINT
#-----------------------------------------------------------------------------------------------------------------------
clear
echo " "
echo -e "       ${BLUE} +-+-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+${NC}"
echo -e "       ${WHITE} 🚀  |U|n|d|e|r|S|e|r|v|e|d| |P|l|a|t|f|o|r|m| |I|n|s|t|a|l|l|a|t|i|o|n|${NC}"
echo -e "       ${BLUE} +-+-+-+-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+ +-+-+-+-+-+-+-+-+-+-+-+-+-+-+-+${NC}"


section_header " ℹ️  Welcome to the UnderServed Platform Installation Script!"
echo -e "This script will guide you through the installation process.If you are unsure how to answer any"
echo -e "questions during the installation, please consult the ${BLUE}Platform Installation Guide${NC}."
divider
# Pause before continuing
read -p "Press Enter to continue ..."
#-----------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------
# DEPENDENCY CHECKER, e.g. docker, python libraries
#-----------------------------------------------------------------------------------------------------------------------
check_deps() {
    section_header "💡 Checking Dependencies"

    if docker compose version 2> /dev/null; then
        echo -e "Docker  ✅"
    else
        echo -e "${RED}❌ Docker is not installed on this server.${NC}"
	echo -e "${WHITE}Don't panic! This is expected for a first time installation. The script will now install Docker...${NC}"
        sudo bash install_docker.sh
        sudo usermod -aG docker "$USER"
        sudo usermod -aG www-data "$USER"
        sudo -k
       echo -e "${GREEN}****A server reboot is now required. After reboot, please log in to the server and re-run the deploy.sh script.****${NC}"
	read -p " ⚠️  Press Enter to reboot"
	sudo reboot
        exit 10
    fi


    if python3 -m venv tmpvenv >/dev/null 2>&1; then
        echo -e "Python venv  ✅"
        rm -rf tmpvenv || exit 45
    else
        echo -e "${RED}Python VENV not found${NC}  ❌ .... Installing Now"
        echo "⚠️  You will be prompted for your password to allow this."
        sudo apt update
        sudo apt install tmux python3-venv python-is-python3 python3-pip libpango-1.0-0 libpangoft2-1.0-0 -y
        pip install weasyprint
	    pip install pymisp
        sudo -k
    fi
}
#-----------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------
# INISTIALISE AND CHECKOUT GIT SUBMODULES
#-----------------------------------------------------------------------------------------------------------------------
init_git() {
    git submodule update --init
    git submodule update --checkout
}
#-----------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------
# CREATE DOCKER INFRASTUCTRE - NETWORKS & VOLUMES
#-----------------------------------------------------------------------------------------------------------------------
create_docker_network() {
    docker network create docker_underserved && echo "Creating docker network" ||  echo "Permission issues with running docker commands? Take note if the script fails here."
}

create_docker_volumes() {
    echo "Creating Docker Volumes for expected services"
    docker_volumes=("underserved-misp_mysql_data" "underserved-misp_files" "underserved-misp_ssl" "underserved-misp_gnupg" "underserved-cerebrate_mysql_data" "underserved-decider_postgres_data" "underserved-lookyloo_scraped" "underserved-lookyloo_archived_captures" "underserved-lookyloo_discarded" "underserved-pandora_storage" "underserved-keycloak_postgres_data")
    for docker_volume in "${docker_volumes[@]}"; do
        docker volume create "$docker_volume"
    done
}
#-----------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------
# CREATE PLATFORM PASSWORD
#-----------------------------------------------------------------------------------------------------------------------
gen_passwd() {
    export platform_password=$(openssl rand -base64 48 | tr -dc 'A-Za-z0-9!@#$%^&*()_+=-' | head -c 32)
}

# gen_secret() {
#    local num_bytes="${1:-24}"  # Default number of bytes is 24 if not provided
#    openssl rand -base64 "$num_bytes" | tr -dc 'a-zA-Z0-9'

#-----------------------------------------------------------------------------------------------------------------------




#-----------------------------------------------------------------------------------------------------------------------
# GET DOMAIN DETAILS, ORGANISATION AND ADMIN EMAIL
#-----------------------------------------------------------------------------------------------------------------------
get_domain() {
    if [[ -f "misp-docker/.env" ]]; then
        controlled_domain=$(grep "^BASE_URL" misp-docker/.env | awk -F "=" '{print $2}' | grep -oP '(?<=misp\.)\S+')
    fi
    if [[ -z $controlled_domain ]]; then
        # Get domain for using the service
        section_header "🌐 Platform Fully Qualified Domain Name (FQDN), e.g. underserved.myngo.com"
        echo "Please enter the Fully Qualified Domain Name (FQDN) of this server."
        echo "If you are unsure about this setting, contact your network administrator or refer to"
        echo "the platform installation documentation."
        echo ""
        read -rp "Enter FQDN:" controlled_domain
    else
        echo -e "Domain currently set to ${RED}$controlled_domain${NC}"
    fi
    export controlled_domain
}

get_organisation() {
    if [[ -f "misp-docker/.env" ]]; then
        organisation=$(grep "^ADMIN_ORG" misp-docker/.env | awk -F "=" '{print $2}')
    fi
    if [[ -z $organisation ]]; then
        # Get domain for using the service
	section_header "ℹ️  Your Organisation Details and Email Addresss"
        echo -e "Enter the name of your Organisation (No Spaces)"
        read -rp "Org Name: " organisation
    else
        echo -e "Organisation currently set to: ${RED}$organisation${NC}"
    fi
    export organisation
}

get_admin_email() {
    if [[ -f "misp-docker/.env" ]]; then
        admin_email=$(grep "^ADMIN_EMAIL" misp-docker/.env | awk -F "=" '{print $2}')
    fi
    if [[ -z $admin_email ]]; then
        # Get domain for using the service
        echo -e "Enter your email address"
        read -rp "Email:" admin_email
    else
        echo -e "Admin email curently set to ${RED}$admin_email${NC}"
    fi
    export admin_email
}

prompt_yes_no() {
    local answer
    read -rp "$1 (y/n): " answer

    # Check the user's response
    if [[ $answer =~ ^[Yy]$ ]]; then
        return 0  # Continue
    elif [[ $answer =~ ^[Nn]$ ]]; then
        echo "Exiting..."
        exit 1
    else
        echo "Invalid input. Please enter 'y' or 'n'."
        prompt_yes_no "$1"  # Prompt again
    fi
}
#-----------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------
# SET VM OVERCOMMIT.  YES RECOMMENED TO OPTIMISE HARDWARE USAGE
#-----------------------------------------------------------------------------------------------------------------------
check_vm_overcommit() {
    overcommit_memory=$(cat /proc/sys/vm/overcommit_memory)

    if [ "$overcommit_memory" -eq 0 ]; then
	section_header "ℹ️  Configure VM Memory Overcommit (yes recommended)"
        echo "Heuristic overcommit handling is enabled. Overcommit MUST be enabled"
        echo "Please add vm.overcommit_memory=1 to the end of the /etc/sysctl.conf file"
        echo "and run the command: sudo sysctl -p"
        prompt_yes_no "Press (y) to make the necessary changes automatically"
        echo "vm.overcommit_memory=1" | sudo tee -a /etc/sysctl.conf >/dev/null
        sudo sysctl -p
        sudo -k
    elif [ "$overcommit_memory" -eq 1 ]; then
        echo "Always overcommit is already enabled."
        # Perform actions when always overcommit is enabled
    elif [ "$overcommit_memory" -eq 2 ]; then
        echo "Please add vm.overcommit_memory=1 to the end of the /etc/sysctl.conf file"
        echo "and run the command: sudo sysctl -p"
        prompt_yes_no "Press (y) to make the necessary changes automatically"
        echo "vm.overcommit_memory=1" | sudo tee -a /etc/sysctl.conf >/dev/null
        sudo sysctl -
        sudo -k
    else
        echo "Unknown value for vm.overcommit_memory: $overcommit_memory"
        echo "Please add vm.overcommit_memory=1 to the end of the /etc/sysctl.conf file"
        echo "and run the command: sudo sysctl -p"
        exit 67
    fi
}
#-----------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------
# CONFIGURE AIL PYSTEMON FEED, MISP INTEGRATION AND SET PASSWORD
#-----------------------------------------------------------------------------------------------------------------------
ail_password() {
    sleep 10
    docker exec -it ail-framework sed -i 's/host = 127.0.0.1/host = 0.0.0.0/g' configs/core.cfg
    docker exec -it ail-framework sed -i 's/host = 127.0.0.1/host = 0.0.0.0/g' configs/core.cfg
    docker exec -it ail-framework sed -i 's#/home/pystemon/pystemon/#/opt/pystemon/#g' /opt/AIL/configs/core.cfg
    docker exec -it ail-framework sed -i 's#/home/pystemon/pystemon/#/opt/pystemon/#g' /opt/AIL/bin/packages/config.cfg
    docker cp configs/AIL/pystemon.yaml ail-framework:/opt/pystemon/


    ail_password="$(docker exec -it ail-framework bin/LAUNCH.sh -rp | grep password:)"

}

ail_config () {
        echo "Configuring AIL Feeder..."
        container=$(docker ps | grep ail-fram | cut -f1 -d' ')
        docker exec -it $container sed -i 's#/home/pystemon/pystemon/#/opt/pystemon/#g' /opt/AIL/configs/core.cfg
        docker exec -it $container sed -i 's#/home/pystemon/pystemon/#/opt/pystemon/#g' /opt/AIL/bin/packages/config.cfg
        docker cp ./configs/AIL/pystemon.yaml $container:/opt/pystemon/
        echo $misp_admin_key
        docker cp ./configs/AIL/mispKEYS.py ail-framework:/opt/AIL/configs/keys/
        docker restart $container
}
#-----------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------
# APPLY GIT PATCHES TO EACH DOCKER COMPOSE AND OTHER CONFIG FILES WITHIN TOOL DIRECTORIES
#-----------------------------------------------------------------------------------------------------------------------
patch_directories() {
    echo "Patching Repositories"
    patch_directories=("cerebrate" "lookyloo" "misp-docker" "pandora" "ail-typo-website")
    if [ -n "$enable_ail" ];then
        patch_directories+=("ail-framework")
    else
        echo " "
    fi
    for patch_dir in "${patch_directories[@]}"; do
        if [ "$patch_dir" == "ail-framework" ]; then
            patch_service="$patch_dir"
            patch_dir="../$patch_service"
        else
            patch_service="$patch_dir"
        fi
        echo "Patching Service: $patch_service"
        cp patches/"$patch_service".patch "$patch_dir"
        pushd "$patch_dir" > /dev/null || exit
        git apply --ignore-space-change --whitespace=nowarn "$patch_service".patch
        popd > /dev/null || exit
    done
}


#-----------------------------------------------------------------------------------------------------------------------
# UPDATE REVERSE PROXY AND PLATFORM HOMEPAGE WWITH CORRECT DOMAIN NAME
#-----------------------------------------------------------------------------------------------------------------------
patch_rprox_domain() {
    echo "Configuring reverse proxy domain"
     find ./nginx/ -type f -name '*.conf' -exec sed  "s/underserved\.org/$controlled_domain/g" -i {} \;
}

patch_homepage_domain() {
    echo "Configuring reverse proxy domain"
    find ./homepage/ -type f -name '*.yaml' -exec sed  "s/underserved\.org/$controlled_domain/g" -i {} \;
    sed -i  "s/underserved\.org/$controlled_domain/g" ./docker-compose.yml
}

patch_keycloak_domain() {
    echo "Configuring keycloak domain"
    find ./keycloak/ -type f -name '*.yaml' -exec sed  "s/underserved\.org/$controlled_domain/g" -i {} \;
    sed -i  "s/underserved\.org/$controlled_domain/g" ./docker-compose.yml
}



#-----------------------------------------------------------------------------------------------------------------------
# UPDATE MISP-FORMS, MKDOCS, AND PATCHES WWITH CORRECT DOMAIN NAME
#-----------------------------------------------------------------------------------------------------------------------
patch_misp_forms() {
    echo "Configuring reverse proxy domain"
    find ./misp-forms/ -type f -name '*.*' -exec sed  "s/underserved\.org/$controlled_domain/g" -i {} \;
}

patch_mkdocs() {
    echo "Configuring reverse proxy domain"
    find ./underserved-mkdocs/ -type f -name '*.*' -exec sed  "s/underserved\.org/$controlled_domain/g" -i {} \;
}

patch_configs() {
    echo "Update config files for domain"
    find ./configs/ -type f -name '*.*' -exec sed  "s/underserved\.org/$controlled_domain/g" -i {} \;
}
#-----------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------
#  SETUP MISP, SPECIFY BASE URL, CREDNTIALS, API KEYS
#-----------------------------------------------------------------------------------------------------------------------
setup_misp() {
    echo "Adding MISP env file"
    pushd misp-docker || exit
    if [ -f ./.env ]; then
        echo "Existing env config found for MISP .... skipping"
        misp_admin_password=$(grep "^ADMIN_PASSWORD" .env | awk -F "=" '{print $2}')
        misp_admin_key=$(grep "^ADMIN_KEY" .env | awk -F "=" '{print $2}')
        misp_oidc_secret=$(grep "^OIDC_CLIENT_SECRET" .env | awk -F "=" '{print $2}')
    else
        cp template.env .env
        misp_admin_email=$admin_email
        misp_admin_org=$organisation
        misp_admin_key=$(< /dev/urandom tr -dc 'A-Za-z0-9' | head -c 40; echo)
        misp_admin_password=$(openssl rand -base64 48 | tr -dc 'A-Za-z0-9!@#$%^&*()_+=-' | head -c 32) #(openssl rand -base64 16 | tr -dc 'a-zA-Z0-9')
        sed -i 's/^# DISABLE_IPV6=true/DISABLE_IPV6=true/' .env
        sed -i "s,^BASE_URL=,BASE_URL=https://misp.$controlled_domain," .env # This  should be user defined during start up
        sed -i "s/^ADMIN_EMAIL=/ADMIN_EMAIL=$misp_admin_email/" .env
        sed -i "s/^ADMIN_ORG=/ADMIN_ORG=$misp_admin_org/" .env
        sed -i "s/^ADMIN_KEY=/ADMIN_KEY=$misp_admin_key/" .env
        sed -i "s/^ADMIN_PASSWORD=/ADMIN_PASSWORD=$misp_admin_password/" .env


        # Generate and export OpenID client-secret
        # for use by KC setup
        # TBC CONFIG MISP TO USE OIDC
        misp_oidc_secret=$(openssl rand -base64 24 | tr -dc 'a-zA-Z0-9')

        #sed -i "s/^# OIDC_ENABLE=/OIDC_ENABLE=true/" .env
        sed -i "s/^# OIDC_PROVIDER_URL=/OIDC_PROVIDER_URL=https:\/\/keycloak.$controlled_domain\/realms\/${controlled_domain^^}/" .env
        sed -i "s/^# OIDC_CLIENT_ID=/OIDC_CLIENT_ID=misp/" .env
        sed -i "s/^# OIDC_CLIENT_SECRET=/OIDC_CLIENT_SECRET=$misp_oidc_secret/" .env
        sed -i "s/^# \(OIDC_ROLES_PROPERTY=\).*/\1\"misp-role\"/" .env
        role_mapping='{"misp-admin": "1", "misp-orgadmin": "2", "misp-user": "3", "misp-sync": "5"}'
        sed -i "s/^# \(OIDC_ROLES_MAPPING=\).*/\1\"$(echo $role_mapping | sed -e 's/"/\\\\"/g')\"/" .env
        sed -i "s/^# OIDC_DEFAULT_ORG=/OIDC_DEFAULT_ORG=1/" .env



    fi

    export misp_oidc_secret
    export misp_admin_key
    export misp_admin_password
    popd > /dev/null || exit
}

misp_exports() {
    misp_user=$admin_email
    misp_password=$misp_admin_password
    misp_api=$misp_admin_key
    export misp_user
    export misp_password
    export misp_api
}

misp_config() {
    sed -i "s/underserved\.org/$controlled_domain/g" configs/MISP/misp-taxo.py
    sed -i "s/misp-api-key/$misp_admin_key/" configs/MISP/misp-taxo.py
    sed -i "s/misp-api-key/$misp_admin_key/g" configs/AIL/mispKEYS.py
    pip install pymisp #if not install, install now
    python3 configs/MISP/misp-taxo.py 2> /dev/null
    (crontab -l 2>/dev/null; echo "*/5 * * * * docker exec misp-docker-misp-core-1 /var/www/MISP/app/Console/cake Server pullAll 1 full") | crontab -
}
#-----------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------
# SETUP PANDORA, CREATE AND UPDATE CONFIG FILES, ADD MISP API KEY
#-----------------------------------------------------------------------------------------------------------------------
setup_pandora() {
    echo "Adding pandora generic.json file"
    pushd pandora || exit
    if [ -f ./config/generic.json ]; then
        echo "Existing generic.json file found for pandora ... skipping"
    else
        cp config/generic.json.sample config/generic.json # TODO Adding generated passwords and details and also adding logging config
	    cp -rf ../configs/pandora/* pandora/workers
        sed -i 's/"storage_db_hostname": "127.0.0.1"/"storage_db_hostname": "kvrocks"/' config/generic.json
	    sed -i 's/"apikey": ""/"apikey": "'"$misp_admin_key"'"/g' config/generic.json
	    sed -i 's|"url": ""|"url": "https://misp-docker-misp-core-1"|g' config/generic.json
	    sed -i 's/"tls_verify": true/"tls_verify": false/g' config/generic.json
	    sed -i 's/"autopublish": false/"autopublish": true/g' config/generic.json
	    sed -i 's/"show_project_page": true/"show_project_page": false/g' config/generic.json
	    sed -i 's/"users": {}/"users": {"admin":"'$misp_admin_password'"}/g' config/generic.json
        #sed -i 's/"enabled": false/"enabled": true/g' config/generic.json
	    sed -i 's/can_submit_to_misp: false/can_submit_to_misp: true/g' config/roles.yml
    fi
    popd > /dev/null || exit
}
#-----------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------
# SETUP LOOKYLOO, CREATE AND UPDATE CONFIG FILES, ADD MISP API KEY
#-----------------------------------------------------------------------------------------------------------------------
setup_lookyloo() {
    echo "Adding Lookyloo generic.json file"
    pushd lookyloo > /dev/null || exit

    cp config/generic.json.sample config/generic.json
    sed -i "s/\"users\": {}/\"users\": {\"admin\":\"${misp_admin_password//&/\\&}\"}/g" config/generic.json
    sed -i 's/"show_project_page": true,/"show_project_page": false,/g' config/generic.json
    sed -i 's/"async_capture_processes": 1,/"async_capture_processes": 5,/' config/generic.json
    cp ../configs/lookyloo/modules.json config/modules.json
    sed -i "s/misp-api-key/${misp_admin_key//&/\\&}/g" config/modules.json
    #sed -i 's|https://misp.url|https://misp-docker-misp-core-1|g' config/modules.json
    sed -i "s|https://misp.url|https://misp.${controlled_domain}|g" config/modules.json
    sed -i "s/myorg.local/$controlled_domain/g" config/generic.json
    docker compose restart

    popd || exit
}
#-----------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------
# SETUP PANDORA, CREATE AND UPDATE CONFIG FILES, SET PASSWORD
#-----------------------------------------------------------------------------------------------------------------------
setup_decider() {
    pushd decider > /dev/null || exit
    if [ -f ./.env ]; then
        echo "Existing env config found for decider .... skipping"
        decider_db_password=$(grep "DB_ADMIN_PASS" .env | awk -F "=" '{print $2}')
        export decider_db_password
        decider_cartenc_key=$(grep "CART_ENC_KEY" .env | awk -F "=" '{print $2}')
        export decider_cartenc_key
    else
        decider_db_password=$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9')
        export decider_db_password
        decider_cartenc_key=$(openssl rand -base64 24 | tr -dc 'a-zA-Z0-9')
        export decider_cartenc_key
        cp .env.docker .env
        sed -i "s/DB_ADMIN_PASS=/DB_ADMIN_PASS=$decider_db_password/g" .env
        sed -i "s/DB_KIOSK_PASS=/DB_KIOSK_PASS=$decider_db_password/g" .env
        sed -i "s/CART_ENC_KEY=/CART_ENC_KEY=$decider_cartenc_key/g" .env
        sed -i "s/127.0.0.1/0.0.0.0/g" .env
        sed -i "s/APP_ADMIN_PASS=/APP_ADMIN_PASS=\"Unserv-Pass\"/g" .env
        cp -r default_config/. config/
    fi
    popd > /dev/null || exit
}
#-----------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------
# SETUP MISP-FORMS, CREATE AND UPDATE CONFIG FILES, SET PASSWORD, ADD STANDARD USER.
#-----------------------------------------------------------------------------------------------------------------------
setup_misp_forms() {
  echo "Configuring MISP-Forms"
  secret_key=$(openssl rand -hex 32)
  pushd misp-forms > /dev/null || exit
  cp template.env .env
  sed -i "s/FLASK_SECRET_KEY=/FLASK_SECRET_KEY=${secret_key}/g" .env
  sed -i "s/misp-org1-apikey/${misp_admin_key}/g" misp_keys.json # REQUIRED FOR SUPERNODE WHEN INPUT FROM MORE THAT ONE NGO
  sed -i "s/misp-org1-apikey/${misp_admin_key}/g" blueprints/typo_squatting.py  # supports submission to misp from
  sed -i "s/org1/${organisation}/g" misp_keys.json
  popd > /dev/null || exit
}

# create standard user
create_misp_forms_user(){
        sed -i "s/underserved\.org/$controlled_domain/g" configs/MISP/misp_forms_user.py
        sed -i "s/misp-api-key/$misp_admin_key/" configs/MISP/misp_forms_user.py
        pip install pymisp # if not already installed
        python3 configs/MISP/misp_forms_user.py
	cd misp-forms
	docker compose down
	docker compose up -d --build
	cd ../
}
#-----------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------
# SETUP CEREBRATE ADD DEFAULT ORGANISATION
#-----------------------------------------------------------------------------------------------------------------------
initialise_cerebrate() {
    pushd cerebrate/docker > /dev/null || exit
    if [ -f ./.env ]; then
        echo "Existing env config found for decider .... skipping"
        cerebrate_db_password=$(grep "CEREBRATE_DB_PASSWORD" .env | awk -F "=" '{print $2}')
        cerebrate_security_salt=$(grep "CEREBRATE_SECURITY_SALT" .env | awk -F "=" '{print $2}')
    else
        cerebrate_db_password=$(openssl rand -base64 12 | tr -dc 'a-zA-Z0-9')
        echo "CEREBRATE_DB_PASSWORD=$cerebrate_db_password" > .env

        cerebrate_security_salt=$(openssl rand -base64 24 | tr -dc 'a-zA-Z0-9')
        echo "CEREBRATE_SECURITY_SALT=$cerebrate_security_salt" >> .env
    fi
    export cerebrate_db_password
    export cerebrate_security_salt

    if [[ ! -f "./etc/config.json" ]]; then
        echo "Generating application config"
        org_uuid=$(uuidgen)
        export org_uuid

        # Generate and export OpenID client-secret
        # for use by KC setup
        cerebrate_oidc_secret=$(openssl rand -base64 24 | tr -dc 'a-zA-Z0-9')
        export cerebrate_oidc_secret

        cat > ./etc/config.json <<- APPCONF
        {
            "App.fullBaseUrl": "https:\/\/cerebrate.${controlled_domain}",
            "App.baseurl": "https:\/\/cerebrate.${controlled_domain}",
            "App.uuid": "${org_uuid}",
            "Proxy.host": "",
            "Proxy.port": "",
            "Proxy.user": "",
            "password_auth.enabled": true,
            "keycloak.enabled": false,
            "keycloak.provider.applicationId": "cerebrate",
            "keycloak.provider.applicationSecret": "${cerebrate_oidc_secret}",
            "keycloak.provider.realm": "${controlled_domain^^}",
            "keycloak.provider.baseUrl": "https:\/\/keycloak.${controlled_domain}",
            "keycloak.screw": "30",
            "security.logging.ip_source": "HTTP_X_FORWARDED_FOR",
            "security.registration.self-registration": true,
            "security.registration.floodProtection": true,
            "debug": false
        }
APPCONF
    fi
    # ensure correct ownership
    chgrp www-data ./etc/config.json

    popd > /dev/null || exit
}


set_default_credentials() {
    export cerebrate_user="admin@local.org"
    export cerebrate_password=$platform_password #$(openssl rand -base64 48 | tr -dc 'A-Za-z0-9!@#$%^&*()_+=-' | head -c 32)      # =$(openssl rand -base64 18 | tr -d '=+/[:space:]' | cut -c1-24)
}


# Import MISP organisation into Cerebrate
cerebrate_import() {
        container=$(docker ps | grep cerebrate | cut -d" " -f 1)
        docker exec $container curl --insecure -H "Authorization: $misp_admin_key" -H "Accept: application/json" -o organisations.json "https://misp.$controlled_domain/organisations/index.json"
        docker exec $container bin/cake Importer -y -v src/Command/config/config-misp-format-organisation.json ./organisations.json
	echo -e "${YELLOW}Importing Organisation details to Cerebrate ...${NC}"
	sudo chown -R 33:33 ./cerebrate/docker/run/logs
	#update import script
	sed -i  's/misp-key/$misp_admin_key/g' ./utilities/cerebrate_import.sh
	sed -i  's/misp-host/$controlled_domain/g' ./utilities/cerebrate_import.sh
}
#-----------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------
# GENERATE AND INSTALL PRIVATE SSL CERTIFICATES
#-----------------------------------------------------------------------------------------------------------------------
generate_certs() {
    section_header "🔒 Generate SSL Certs"
    echo -e "${RED}Note:${NC} During the platform deployment private SSL certs are used, therefore you"
    echo "may get browser security warnings when you connect to the platform.  See the User Guide"
    echo "for information on adding valid SSL Certs to the plaftorm."
    echo ""
    divider
    read -p "Press Enter key to continue ..."
    bash utilities/generate-ssl.sh
    divider
}

#-----------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------
# BEGIN PROCESS OF CREATING IMAGES AND BUILDING CONTAINERS
#-----------------------------------------------------------------------------------------------------------------------
start_containers() {
    section_header "⏳  Build UnderServed Docker Images and Start Containers"
    echo "This process takes between 25-50 mins. Once complete you will be prompted to reboot the server"
    echo ' '
    read -p "Press Enter to Continue ..."


    directories=("cerebrate/docker" "lookyloo" "misp-docker" "misp-forms" "pandora" "decider" "keycloak" "ail-typo-website" "underserved-mkdocs" "portainer" "ail" ".")
    for dir in "${directories[@]}"; do
        echo "Enabling Service: $dir"
        pushd "$dir" > /dev/null || echo "Issue deploying $dir"
        docker compose up -d && echo "Deployed $dir OK"
        popd > /dev/null || echo "Issue deploying $dir"
    done
}
#-----------------------------------------------------------------------------------------------------------------------



#-----------------------------------------------------------------------------------------------------------------------
# SET PORTAINER PASSWORD
#-----------------------------------------------------------------------------------------------------------------------
reset_portainer_password(){
  cd portainer || { echo "Failed to change to 'portainer' directory. Exiting."; exit 1; }
  docker stop portainer > /dev/null
  portainer_password="$(docker run --rm -v ./portainer_data:/data portainer/helper-reset-password 2>&1 | grep password | awk '{print $NF}')"
  docker start portainer > /dev/null
  cd ../
  export portainer_password
}
#-----------------------------------------------------------------------------------------------------------------------


#-----------------------------------------------------------------------------------------------------------------------
# SCRIPT COMPLETION PAGE WITH CREDENTIALS
#-----------------------------------------------------------------------------------------------------------------------
ask_for_reboot() {
    clear
    echo -e "${BLUE}===================================================${NC}"
    echo -e "${GREEN}        Platform Installation Successful ✅         ${NC}"
    echo -e "${BLUE}===================================================${NC}"
    echo ""
    echo -e "🌐${CYAN} Platform URL:${NC} https://$controlled_domain  ${WHITE}(Currently using private SSL Certs)${NC}" 
    echo ""
    echo -e "🔑${GREEN} Platform Credentials${NC}"
    echo -e "${BLUE}--------------------------------------------------------------------------------${NC}"
    # Table header
    printf "%-28s | %-40s\n" "Service" "Credentials"
    echo -e "${BLUE}--------------------------------------------------------------------------------${NC}"
    # MISP/Pandora/Lookyloo
    printf "%-28s | %-40s\n" "MISP/Pandora/Lookyloo:" "Username: $admin_email"
    printf "%-28s | %-40s\n" "" "Password: $misp_admin_password"
    echo -e "${BLUE}--------------------------------------------------------------------------------${NC}"
    # AIL-Framework
    printf "%-28s | %-40s\n" "AIL-Framework:" "Username: admin@admin.test"
    printf "%-28s | %-40s\n" "" "Password: $ail_password"
    echo -e "${BLUE}--------------------------------------------------------------------------------${NC}"
    # Portainer
    printf "%-28s | %-40s\n" "Portainer Docker Manager:" "Username: admin"
    printf "%-28s | %-40s\n" "" "Password: $portainer_password"
    echo -e "${BLUE}--------------------------------------------------------------------------------${NC}"
    # Cerebrate
    printf "%-28s | %-40s\n" "Cerebrate:" "Username: admin"
    printf "%-28s | %-40s\n" "" "Password: Password1234 (CHANGE PASSWORD on first login)"
    echo -e "${BLUE}--------------------------------------------------------------------------------${NC}"
     # Keycloak
    printf "%-28s | %-40s\n" "Keycloak:" "Username: kc_admin"
    printf "%-28s | %-40s\n" "" "Password: kc_sapp (CHANGE PASSWORD on first login)"
    echo -e "${BLUE}--------------------------------------------------------------------------------${NC}"
    echo ""
    echo -e "${RED}***Please note these credentials before you reboot***${NC}"
    echo ""
    while true; do
        echo -e "⚠️  To complete setup, a reboot of the server is strongly recommended."
        read -rp "Would you like to reboot the server now? (Y/N): " answer
        case "$answer" in
            [Yy]* ) echo "Rebooting now..."; sudo reboot; exit ;;
            [Nn]* ) echo "Reboot skipped. Please reboot manually when ready."; exit ;;
            * ) echo "Please answer Y or N." ;;
        esac
    done
}
#-----------------------------------------------------------------------------------------------------------------------



#-----------------------------------------------------------------------------------------------------------------------
# FUNCTION CALLS
#-----------------------------------------------------------------------------------------------------------------------
check_deps
init_git
create_docker_network
create_docker_volumes
check_vm_overcommit
gen_passwd
get_domain
patch_keycloak_domain
get_organisation
get_admin_email
patch_directories
patch_rprox_domain
patch_homepage_domain
patch_misp_forms
patch_mkdocs
setup_misp
setup_pandora
setup_lookyloo
setup_decider
setup_misp_forms
initialise_cerebrate
set_default_credentials
generate_certs
start_containers
misp_exports
export controlled_domain
export decider_cartenc_key
export decider_db_password
export admin_email
export misp_user
export misp_password
export misp_api
misp_config
ail_config
cerebrate_import
ail_password
create_misp_forms_user
reset_portainer_password
ask_for_reboot


