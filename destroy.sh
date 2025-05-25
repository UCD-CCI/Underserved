
#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'


# log files
#exec > >(tee -a "logs/uninstall.log")  
#exec 2> >(tee -a "logs/Uninstall_error.log" >&2) 

echo -e "${BLUE}*************************************************${NC}"
echo -e "${BLUE}UnderServed Platform Removal Script${NC}"
echo "     "
echo -e "${RED}🚨  WARNING: All docker containers, volumes, and networks will be deleted during this process 🚨${NC}"
echo "     "
echo -e "${BLUE}*************************************************${NC}"
echo "     "
read -p  "Press Enter to Continue or Ctrl - C to Quit"
echo "      "



echo -e "${GREEN}*************************************************${NC}"
echo -e "${GREEN}Removing Docker containers${NC}"
echo " "
echo -e "${GREEN}*************************************************${NC}"
echo " "

directories=("cerebrate/docker" "lookyloo" "misp-docker" "misp-forms" "pandora" "decider" "keycloak" "ail-typo-website" "underserved-mkdocs" "portainer" "dnstwist" "ail" ".")

for dir in "${directories[@]}"; do
    echo "Removing Service: $dir"
    pushd "$dir" > /dev/null || echo "Issue removing $dir, likely AIL not installed"
    docker compose down -v
    popd > /dev/null || echo "Issue removing $dir"
done

for dir in "${directories[@]}"; do
    echo "Resetting Submodules: $dir"
    if pushd "$dir" > /dev/null; then
        git reset --hard
        git clean -dfx
        popd > /dev/null
    else
        echo "Issue changing to $dir, likely AIL not installed or directory does not exist"
    fi
done

echo -e "${GREEN}*************************************************${NC}"
echo -e "${GREEN}Delete SSL Certificates (yes/no)${NC}"
echo " "
echo -e "${GREEN}*************************************************${NC}"

read -r ssl_removal

if [ "$ssl_removal" = "yes" ]; then
    echo "Deleting SSL Certificates"
    rm -rf ngnix/ssl/*
elif [ "$ssl_removal" = "no" ]; then
    echo "SSL certifcation unchanged"
else
    echo "Invalid response. Exiting."
    exit 1
fi

echo -e "${GREEN}*************************************************${NC}"
echo -e "${GREEN}Delete Docker Volumes?(yes/no)${NC}"
echo " "
echo -e "${GREEN}*************************************************${NC}"

read -r docker_volume_removal

if [ "$docker_volume_removal" = "yes" ]; then
    echo "Removing Docker Volumes for expected services"
    docker_volumes=("underserved-misp_mysql_data" "underserved-misp_files" "underserved-misp_ssl" "underserved-misp_gnupg" "underserved-cerebrate_mysql_data" "underserved-decider_postgres_data" "underserved-lookyloo_scraped" "underserved-lookyloo_archived_captures" "underserved-lookyloo_discarded" "underserved-pandora_storage" "underserved-keycloak_postgres_data")
    for docker_volume in "${docker_volumes[@]}"; do
        docker volume rm "$docker_volume"
    done
elif [ "$docker_volume_removal" = "no" ]; then
    echo "Leaving docker volumes for services alone"
else
    echo "Invalid response. Exiting."
    exit 1
fi

echo -e "${GREEN}*************************************************${NC}"
echo -e "${GREEN}Removing Docker Networks${NC}"
echo " "
echo -e "${GREEN}*************************************************${NC}"

# Ensure all containers are stopped and purge all docker objects
docker stop $(docker ps -q) 2> /dev/null
docker system prune -a -f

echo -e "${BLUE}*************************************************${NC}"
echo -e "${BLUE}Removal Script Completed Successfully${NC}"
echo "   "
echo "A reboot is recommended but not essential"
echo -e "${BLUE}*************************************************${NC}"



