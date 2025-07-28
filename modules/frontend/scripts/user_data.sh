# # #!/bin/bash
# # # Update system
# # sudo apt update -y

# # # Install SSM Agent
# # sudo snap install amazon-ssm-agent --classic
# # sudo systemctl enable amazon-ssm-agent
# # sudo systemctl start amazon-ssm-agent



# #!/bin/bash


# # AWS_REGION="us-east-1"
# # Update system packages
# sudo apt update -y 

# # Install necessary tools
# sudo apt install -y curl unzip 

# # Download and install the latest SSM Agent
# curl -O https://s3.amazonaws.com/amazon-ssm-${AWS_REGION:-us-east-1}/latest/debian_amd64/amazon-ssm-agent.deb
# sudo dpkg -i amazon-ssm-agent.deb

# # Enable and start the agent
# sudo systemctl enable amazon-ssm-agent
# sudo systemctl start amazon-ssm-agent

# # sudo systemctl enable apache2
# # sudo systemctl start apache2





# # #!/bin/bash
# # # set -e

# # # Update and install dependencies
# # apt update -y
# # apt install -y curl unzip

# # # Download and install the session manager plugin
# # curl "https://s3.amazonaws.com/session-manager-downloads/plugin/latest/ubuntu_64bit/session-manager-plugin.deb" -o session-manager-plugin.deb
# # dpkg -i session-manager-plugin.deb

# # # Optional: clean up
# # rm -f session-manager-plugin.deb


#!/bin/bash
set -e

# Update packages and install core tools
sudo apt update -y
sudo apt install -y snapd curl apache2

# Wait for cloud-init and snap to be ready
sleep 10

# Install the SSM Agent via snap (only if not already present)
if ! sudo systemctl status amazon-ssm-agent >/dev/null 2>&1; then
    sudo snap install amazon-ssm-agent --classic
fi

# Start and enable the SSM agent
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent

# # Start and enable Apache
# sudo systemctl enable apache2
# sudo systemctl start apache2

# # Serve a simple page
# cd /var/www/html
# sudo rm -rf *
# echo "Hello, Omokaro" | sudo tee index.html


# Start and enable Apache
systemctl start apache2
systemctl enable apache2

# Clean default page and create new one
rm -f /var/www/html/index.html
echo "Hello, Omokaro - it works!" > /var/www/html/index.html