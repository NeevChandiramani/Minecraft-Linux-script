#!/bin/bash

# Check if the user has sudo privileges
if sudo -v >/dev/null 2>&1; then
  echo "You have sudo privileges. Proceeding with the installation."
  sleep 3 # Pause for 3 seconds
else
  echo "Sorry, you don't have sudo privileges. Installation aborted."
  exit 1
fi

# Update & Upgrade
sudo apt update && sudo apt upgrade -y

# Basic utilities installation
sudo apt install -y net-tools curl wget docker.io

# Check if the system is up to date
if apt-get upgrade -s | grep -q "upgraded,"; then
  echo "Done! The system is up to date."
else
  echo "Installation not successful."
fi

# Ask a question and read user input in order to install a Minecraft server or not.
read -p "Do you want to install a Minecraft server? (y/n): " answer

# Process the user's response
if [ "$answer" == "y" ]; then
  echo "Great! Let's proceed."

  # Check available RAM
  ram=$(free -h --si | awk '/^Mem:/ {print $2}')
  required_ram="2G"

  echo "Checking available RAM..."
  sleep 3  # Pause for 3 seconds
  echo "Your system has $ram of RAM."

  if [ "$ram" \< "$required_ram" ]; then
    echo "Insufficient RAM. Minimum 2GB of RAM is required to install the Minecraft server."
    sleep 1
    echo "Installation aborted."
    sleep 2
  else
    echo "RAM check passed. Installing the Minecraft server..."
    sleep 3  # Pause for 3 seconds

    sudo docker run -d -it -p 25565:25565 -e EULA=TRUE itzg/minecraft-server

    echo "Done! Your server is running on localhost:25565"
    sudo docker rename $(sudo docker ps -lq) Minecraft_Server
  fi
  
elif [ "$answer" == "n" ]; then
  echo "Okay, See you soon."
  sleep 3 # Pause for 3 seconds

else
  echo "Invalid response. Please enter 'y' or 'n'."
fi
