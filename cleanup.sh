#!/bin/bash

# Function to remove users and the cloud group
remove_user_and_group() {
  # Define the users array
  users=("Dengklek" "Bocchi" "Mate" "Asep")

  # Remove the users
  for user in "${users[@]}"; do
    sudo userdel -r "$user" # Delete the user and their home directory
  done

  # Remove the 'cloud' group
  sudo groupdel cloud

  # Remove bocchi from the sudo group
  sudo deluser Bocchi sudo
}

# Function to remove the cloned Git repository
remove_git_repo() {
  # Remove the project directory
  sudo rm -rf /home/cloud/projects/cloud-webapp
}

# Function to remove permissions and access control
remove_permissions() {

  # Reset the ownership and permissions of the directory
  sudo chown -R root:root /home/cloud/projects/cloud-webapp
  sudo chmod -R 755 /home/cloud/projects/cloud-webapp
}

# Function to disable the firewall and remove rules
disable_firewall() {
  # Delete the firewall rules for SSH and HTTP
  sudo ufw delete allow 22
  sudo ufw delete allow 80

  # Reset the default policies
  sudo ufw default allow incoming
  sudo ufw default allow outgoing

  # Disable the firewall
  sudo ufw disable
}

# Function to stop and remove the Docker container and image
remove_docker() {
  # Stop and remove the running container
  sudo docker stop cloud-webapp-container
  sudo docker rm cloud-webapp-container

  # Remove the Docker image
  sudo docker rmi simple-app
}

# Call the functions to undo all changes
remove_user_and_group
remove_git_repo
remove_permissions
remove_docker
disable_firewall

# Display confirmation message
echo "VPS setup has been undone."
echo "Users, GitHub repository, Docker container, and firewall settings have been removed."
