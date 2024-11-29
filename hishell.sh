#!/bin/bash
# Above is a Shebang line, states which interpreter should execute the script (bash, sh, zsh, fish, etc)
# Shebang line must be in the first line of the script

# You can define variables like these
name=Devan
names=("Indra" "Devan") # for array

# To use and access them, you can use dollar sign $ like below
echo "Hello, I'm $name, Cloud Development Mentor"

# To print an entire array
echo "In GDGoC UB Cloud, there is ${names[@]}"

# To access a specific element from array, index starts from 0 to length - 1
echo "We have ${names[0]} as Core of Cloud Development"

# You can pause the program with sleep command
# Below means the program will sleep for 1 second
sleep 1

# You can also execute other linux command in here
# For example, heres the command to ping curriculum module
echo '-----------------------------------------------'
echo 'Checking curriculum module is up or not'
ping gdgc-curriculum-module.vercel.app -c 2
echo '-----------------------------------------------'

# Control structure looks like this
# below is to check if name variable equals to Devan or not
if [ "$name" == "Devan" ]; then
  echo 'Hi Devan! It was enchanting to meet you!'
else
  echo 'Hello stranger! Nice to meet you!'
fi

sleep 1

# Here we run a simple for loop
# notes: each interpreter has different syntax of for loop
#        make sure to check them in documentation
# Looping from 1 until 5, inclusively
echo "Iterating from 1 to 5..."
for i in {1..5}; do
  echo "We are at $i iteration"
done

sleep 1

# If you want to handle user input, you can use read command
read -p "Enter your interest: " interest

# doing while loop with condition if string is empty or not
while [ -z "$interest" ]; do
  echo "Your interest can't be empty!"
  echo "You must have an interest to achieve your true self"
  read -p "Enter your interest: " interest
done

echo "Wow, your interest is $interest! Didn't know that, perhaps you could make some money from it!"

# Lets say we want to quit the program if their interest is Frontend
if [ "$interest" == "Frontend" ]; then
  echo "Im sorry, we don't accept Frontend developers here."
  exit 1
fi

# To define functions or methods, you can define it like below
setup_static_app() {
  app_dir="go-simple-app"
  app_image_name="go-static-web"
  container_name="simple-static-app"

  echo "Setup golang simple static app..."

  # Check if directory already exists or not
  if [ -d "$app_dir" ]; then
    echo "Directory $app_dir already exists"
    echo "Navigating through it"

    cd "$app_dir"

    # Check if file Dockerfile doesn't exists
    if [ ! -f "Dockerfile" ]; then
      echo "Can't find file Dockerfile"
      echo "Exiting..."
      exit 1
    fi

    echo "Remove existing container forcefully"
    docker container rm "$container_name" -f

  else
    echo "Directory doesn't exists"
    echo "Cloning the github repo..."

    git clone https://github.com/gdgc-ub/cloud-simple-dockerfile-study.git "$app_dir"
    cd "$app_dir"

  fi

  echo "Building docker image..."
  docker build -t "$app_image_name" .

  echo "Creating docker container..."
  docker run -d --name "$container_name" -p "80:8080" "$app_image_name"

  docker container ls

  echo "Setup done!"
}

# To call the method or function, just type the function name
setup_static_app
