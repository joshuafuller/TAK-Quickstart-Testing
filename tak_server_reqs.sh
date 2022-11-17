# This script will prepare a server for the installation of the TAK Server
# It will install docker-compose, unzip, zip, git, and net-tools

# Check if script is being run as root
if [ "$EUID" -ne 0 ]
    then echo "Please run as root"
    exit
fi

# Check if running on Ubuntu 20.04 only
if [ -f /etc/os-release ]; then
    . /etc/os-release
    if [ "$ID" = "ubuntu" ] && [ "$VERSION_ID" = "20.04" ]; then
        echo "Running on Ubuntu 20.04"
    else
        echo "This script is only designed to run on Ubuntu 20.04"
        exit
    fi
else
    echo "This script is only designed to run on Ubuntu 20.04"
    exit
fi

echo "#############################################"
echo "Updating apt"
echo "#############################################"


#Update apt repository
apt update
apt upgrade -y

echo "#############################################"
echo "Installing packages"
echo "#############################################"


# Iterate through the list of packages
#  If the package is not installed, install it
#  If the package is installed, skip it
#  Notify the user if the package is already installed
#  Notify the user if the package is successfully installed

#Define the list of packages
packages=(docker-compose unzip wget nano openssl git net-tools)

# Iterate through the list of packages
for package in "${packages[@]}"
do
    if dpkg -s $package >/dev/null 2>&1; then
        echo "------------> $package is already installed"
    else
        echo "------------> Installing $package"
        apt-get install $package -y
    fi
done

echo "#############################################"
echo "Cloning TAK scripts"
echo "#############################################"



#Download atakhq tak-server-install-scripts while checking for errors
echo "Downloading atakhq tak-server-install-scripts"
git clone https://github.com/atakhq/tak-server-install-scripts.git


#Check if folder was created
if [ -d "tak-server-install-scripts" ]; then
    echo "tak-server-install-scripts downloaded successfully"
else
    echo "tak-server-install-scripts failed to download"
    exit
fi

# Call the next script
echo "#############################################"
echo "Calling ./localInstallScript.sh"
echo "#############################################"
#Change directory to tak-server-install-scripts, chmod +x * and run ./localInstallScript.sh
cd tak-server-install-scripts
chmod +x *
./localInstallScript.sh

