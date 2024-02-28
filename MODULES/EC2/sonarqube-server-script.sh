#!/bin/bash

# Update the system
sudo yum update -y

# Install Java OpenJDK 11
sudo amazon-linux-extras install java-openjdk11 -y

# Create a user for SonarQube
sudo adduser sonarqube

# Download SonarQube
sudo -u sonarqube wget https://binaries.sonarsource.com/Distribution/sonarqube/sonarqube-9.4.0.54424.zip -P /home/sonarqube/

# Unzip SonarQube
sudo -u sonarqube unzip /home/sonarqube/sonarqube-9.4.0.54424.zip -d /home/sonarqube/

# Adjust permissions
sudo chmod -R 755 /home/sonarqube/sonarqube-9.4.0.54424
sudo chown -R sonarqube:sonarqube /home/sonarqube/sonarqube-9.4.0.54424

# Start SonarQube
sudo -u sonarqube /home/sonarqube/sonarqube-9.4.0.54424/bin/linux-x86-64/sonar.sh start
