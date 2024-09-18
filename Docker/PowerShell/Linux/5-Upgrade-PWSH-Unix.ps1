# sudo apt update
# sudo apt upgrade




# #run the following from a bash terminal not PWSH terminai

# # Navigate to a temporary directory
# cd /tmp

# # Download the latest PowerShell package
# wget https://github.com/PowerShell/PowerShell/releases/download/v7.4.3/powershell-7.4.3-linux-x64.tar.gz

# # Verify that the file has been downloaded:
# ls -l /tmp/powershell-7.4.3-linux-x64.tar.gz

# # Remove any existing installations:
# sudo rm -rf /usr/local/bin/pwsh
# sudo rm -rf /usr/bin/pwsh
# sudo rm -rf /opt/microsoft/powershell

# # Create a new directory for the new installation:
# sudo mkdir -p /usr/local/bin/pwsh

# # Extract the package
# sudo tar -xzf /tmp/powershell-7.4.3-linux-x64.tar.gz -C /usr/local/bin/pwsh


# # Create a symbolic link to ensure the new version is used:
# sudo ln -sf /usr/local/bin/pwsh/pwsh /usr/bin/pwsh


# # Verify the installation:
# pwsh -version



# # Create a directory for the new PowerShell version
# # mkdir /tmp/powershell-7.4.3








# # Remove the old version if necessary
# # sudo rm -rf /usr/local/bin/pwsh

# # Move the new version to /usr/local/bin
# # sudo mv /tmp/powershell-7.4.3 /usr/local/bin/pwsh

# # Clean up
# rm -rf /tmp/powershell-7.4.3-linux-x64.tar.gz











# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


# echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.profile
# source ~/.profile










sudo apt-get update
sudo apt-get install -y wget apt-transport-https software-properties-common





wget -q https://packages.microsoft.com/keys/microsoft.asc -O- | sudo apt-key add -



sudo sh -c 'echo "deb [arch=amd64] https://packages.microsoft.com/repos/microsoft-ubuntu-bionic-prod bionic main" > /etc/apt/sources.list.d/microsoft.list'

sudo apt-get update


sudo apt-get install -y powershell



pwsh -version

pwsh

$PSVersionTable


