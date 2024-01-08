#!/bin/bash

# Functions to install git

install.git() {
    # Install git
    echo "Installing git..."
    apt install -y git
}

# Functions to create a git user
create.git.user() {
    echo "Creating git user..."
    useradd -m git -d /var/git -s /bin/bash
}

# Functions to create a bare repository

create.repo() {
    read -p "Enter the name for your new repository (e.g., my-repo.git): " repo_name
    su -l git -c "git init --bare /var/git/${repo_name}"
    echo "Repository ${repo_name} created."
}

# Function to set up SSH access for git user
setup_ssh() {
    echo "Setting up SSH access for git user..."
    mkdir /var/git/.ssh
    cp ~/.ssh/authorized_keys /var/git/.ssh/
    chown git:git -R /var/git/.ssh
    echo "SSH setup complete."
}

# Function to add remote repository to a local repository
add_remote() {
    read -p "Enter your domain name: " domain_name
    read -p "Enter the name of your remote repository (e.g., my-repo.git): " remote_repo
    read -p "Enter a unique name for your remote (e.g., personal): " remote_name
    git remote add "${remote_name}" git@"${domain_name}":/var/git/"${remote_repo}"
    echo "Remote ${remote_name} added."
}

# Check if Git is installed, install if not
which git > /dev/null
if [ $? -ne 0 ]; then
    install_git
fi

# Execute the functions
create_git_user
create_repo
setup_ssh
echo "Do you wish to add this repository as a remote to an existing local repository? (yes/no)"
read add_remote_choice
if [ "$add_remote_choice" == "yes" ]; then
    add_remote
fi

echo "Script execution complete!"