#!/bin/bash

# 4. Function to create users and a group
create_user_and_group() {
  echo "----------------------------------------"
  echo "Creating users and group..."

  # 5. Define the users array
  users=("Dengklek" "Bocchi" "Mate" "Asep")

  # 6. Create the 'cloud' group
  sudo groupadd cloud

  # 7. Create users and assign them to the cloud group with passwords
  for i in {0..3}; do
    password="password-$((i + 1))" # Setting the password for each user

    # Create the user with home directory and bash shell
    sudo useradd -m -s /bin/bash "${users[$i]}"

    # Modify the user by adding them to the cloud group
    sudo usermod -aG cloud "${users[$i]}"

    # Set the password for each user
    echo "${users[$i]}:$password" | sudo chpasswd
  done

  # Add Bocchi to the sudo group
  sudo usermod -aG sudo Bocchi
}

# 8. Function to clone the Git repository
clone_git_repo() {
  echo "----------------------------------------"
  echo "Cloning GitHub repository..."

  # 9. Create the projects directory and clone the repository
  sudo mkdir -p /home/cloud/projects
  sudo git clone https://github.com/gdgc-ub/cloud-simple-dockerfile-study.git /home/cloud/projects/cloud-webapp
}

# 10. Function to modify directory permissions
modify_permission() {
  echo "----------------------------------------"
  echo "Modifying directory permissions..."

  # 11. Set the permission for the repository only for cloud group
  sudo chown -R :cloud /home/cloud/projects/cloud-webapp
  sudo chmod -R 775 /home/cloud/projects/cloud-webapp
}

# 12. Function to enable firewall
enable_firewall() {
  echo "----------------------------------------"
  echo "Enabling firewall..."

  # 13. Allow SSH (port 22) and HTTP (port 80) traffic
  sudo ufw allow 22
  sudo ufw allow 80

  # 14. Deny all incoming connections by default
  sudo ufw default deny incoming
  sudo ufw default allow outgoing

  # 15. Enable the firewall and reload it to apply changes
  sudo ufw enable
  sudo ufw reload
}

# 16. Function to build and run the Docker container
build_and_run_docker() {
  echo "----------------------------------------"
  echo "Building and creating container..."

  # 17. Navigate to the project directory
  cd /home/cloud/projects/cloud-webapp

  # 18. Build and create the container that forwards the VPS port 80 to container port 8080
  sudo docker build -t simple-app .
  sudo docker run -d --name cloud-webapp-container -p 80:8080 simple-app
}

# 19. Function to verify the setup
verify_setup() {
  echo "----------------------------------------"
  echo "Verifying setup..."

  # Check running Docker containers
  echo "Checking containers..."
  sudo docker container ls

  # Check firewall rules
  echo "Checking firewall rules..."
  sudo ufw status

  # Check project directory
  echo "Checking directory..."
  ls /home/cloud/projects
}

# 20. Call all functions to perform the setup
create_user_and_group
clone_git_repo
modify_permission
build_and_run_docker
enable_firewall
verify_setup

# 21. Confirmation message
echo '---------------------------------------------------------------'
echo "VPS setup completed. Users created and GitHub repository cloned."
echo "Bocchi is the only user with sudo privileges."
echo "Firewall enabled, only ports 80 (HTTP) and 22 (SSH) are allowed."
echo "Container is already created! Check localhost in your browser to verify!"
