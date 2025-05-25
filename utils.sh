#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' 

# Function to display the menu
display_menu() {
  echo -e "${BLUE}===============================================${NC}"
  echo " UnderServed Manager Utility"
  echo -e "${BLUE}===============================================${NC}"
  echo "1. Restart all UnderServed Docker containers"
  echo "2. Stop all UnderServed Docker containers"
  echo "3. Reboot the server"
  echo "4. Get Platform Admin Username & Password"
  echo "5. Reset Portainer Password"
  echo "6. Reset AIL-Framework Password" 
  echo "7. Exit" 
  echo -e "${BLUE}===============================================${NC}"
  echo -n "Choose an option: "
}

# Function to restart all Docker containers
restart_docker_containers() {
  echo "Restarting all Docker containers..."
  docker restart $(docker ps -a | cut -f1 -d" ")
  echo "All running containers have been restarted."
}

# Function to stop all Docker containers
stop_docker_containers() {
  echo "Stopping all Docker containers..."
  docker stop $(docker ps -q)
  echo "All running containers have been stopped."
}

# Function to reboot the server
reboot_server() {
  echo "Rebooting the server..."
  sudo reboot
}

# Get Platform Admin Username and Password
get_admin_credentials(){
  FILE_TO_SEARCH="misp-docker/.env"

  if [[ ! -f "$FILE_TO_SEARCH" ]]; then
    echo "File not found: $FILE_TO_SEARCH"
    exit 1
  fi

  echo "------------------------------------------------------------"
  grep -B1 -E '^(ADMIN_EMAIL|ADMIN_PASSWORD)=' "$FILE_TO_SEARCH"
  echo "------------------------------------------------------------"
}

reset_portainer_password(){
  echo "Resetting Portainer Password..."
  cd portainer || { echo "Failed to change to 'portainer' directory. Exiting."; exit 1; }
  
  docker stop portainer > /dev/null
  echo "Portainer Docker Manager Login"
  echo "Username: admin"
  printf "Password: %s\n" "$(docker run --rm -v ./portainer_data:/data portainer/helper-reset-password 2>&1 | grep password | awk '{print $NF}')"
  docker start portainer > /dev/null
}

reset_ail_password(){
 echo "Resetting AIL-Framework Password..."
 echo "Username: admin@admin.test"
 printf "Password: %s\n" "$(docker exec -it ail-framework bin/LAUNCH.sh -rp 2>&1 | grep password: | awk '{print $NF}')"
}


# Main script logic
while true; do
  display_menu
  read -r option

  case $option in
    1)
      restart_docker_containers
      ;;
    2)
      stop_docker_containers
      ;;
    3)
      reboot_server
      ;;
    4)
      get_admin_credentials
      ;;
    5)
      reset_portainer_password
      ;;
    6)
      reset_ail_password
      ;;
    7)
      echo "Exiting..."
      break
      ;;
    *)
      echo "Invalid option. Please try again."
      ;;
  esac

  echo ""
  echo "Press Enter to return to the menu..."
  read -r
  clear
done

