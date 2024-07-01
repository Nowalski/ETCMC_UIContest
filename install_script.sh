#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" &> /dev/null
}

# Function to install Python 3 and pip
install_python() {
    echo "Installing Python 3..."
	SUDO=''
	if (( $EUID !=0 ));then
		SUDO='sudo'
                echo "not root"
	fi
    if command_exists apt; then
        $SUDO apt update
    elif command_exists yum; then
        $SUDO yum install -y python3 python3-pip
    else
        echo "Unsupported package manager. Please install Python 3 manually."
        exit 1
    fi
    echo "Python 3 has been installed."
}

# Check if Python 3 is installed
if ! command_exists python3; then
    install_python
else
    echo "Python 3 is already installed."
    $SUDO apt install -y python3-pip
fi

# Install required packages
echo "Installing required packages..."
if ! pip install -r requirements.txt || ! pip install -r requirements.txt --break-system-packages; then
    echo "Attempting with pip3..."
    pip3 install -r requirements.txt || pip3 install -r requirements.txt --break-system-packages
fi

# Set permissions for files
echo "Setting permissions for files..."
chmod +x Linux.py ETCMC_GETH.py geth

echo "Installation complete."

