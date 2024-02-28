#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status
set -u  # Treat unset variables as an error when substituting

# Update the system and install Jenkins
sudo yum update -y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo yum upgrade -y
sudo amazon-linux-extras install java-openjdk11 -y
sudo yum install jenkins -y
sudo systemctl enable jenkins

# Install Git
sudo yum install git -y

# Install Docker
sudo yum install docker -y
sudo systemctl enable docker.service
sudo systemctl start docker.service
sudo usermod -a -G docker jenkins  # Add Jenkins user to the docker group

# Restart Jenkins to apply group membership changes
sudo systemctl start jenkins

# Install Trivy
sudo wget https://github.com/aquasecurity/trivy/releases/download/v0.20.0/trivy_0.20.0_Linux-64bit.rpm
sudo rpm -i trivy_0.20.0_Linux-64bit.rpm

# Clean up downloaded RPM file
rm trivy_0.20.0_Linux-64bit.rpm