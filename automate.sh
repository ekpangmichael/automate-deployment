#!/usr/bin/env bash

# Install node and git
blue=`tput setaf 4`
green=`tput setaf 2`
reset=`tput sgr0`

echoMessage() {
  echo  -e "${1}=================================== ${2} ============================================ ${reset} \n "
}

installCorePackages() {
  source .env
  echoMessage "${blue}" "Updating and installing core packages"
  sudo apt-get update
  sudo apt-get install -y make g++ git curl vim libcairo2-dev libav-tools nfs-common portmap
  echoMessage "${green}" "Packages installed successfuly"
}

installNode() {
  echoMessage "${blue}" "Installing Node and nvm"
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.34.0/install.sh | bash
  source ~/.nvm/nvm.sh
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm install v10.13.0
 echoMessage "${green}"  "Node installed successfuly"
}

# Clone the respository from github

cloneProject() {
  echoMessage "${blue}" "Cloning Respository the repo from github"
  if [[ -d selene-ah-frontend ]]; then
    rm -r selene-ah-frontend
    git clone ${repo}
  else
    git clone ${repo}
  fi
}

# Install necessary dependencies

installDependencies() {
  echoMessage "${blue}" "Installing project dependencies"
  cd selene-ah-frontend
  sudo git checkout aws-deploy
  npm install -ES --unsafe-perm=true
}

# Build and run the project

buildApp() {
  echoMessage "${blue}" "Building and starting the app"
  npm run build
}

# create background process for node
processManager() {
  npm install -g pm2
  clear
  echoMessage "${blue}" "starting node background process"
  pm2 start server.js
}

# check for nginx
installNginx() {
  sudo apt-get install nginx -y
  sudo rm -rf /etc/nginx/sites-enabled/default
  if [[ -d /etc/nginx/sites-enabled/techascode  ]]; then
      echoMessage "${blue}" "Removing existing configuration for nginx"
      sudo rm -r /etc/nginx/sites-available/techascode
      sudo rm -r /etc/nginx/sites-enabled/techascode
  fi
  sudo bash -c 'cat > /etc/nginx/sites-available/techascode <<EOF
   server {
           listen 80;
           server_name '$domainName' '$domainName2';
           location / {
                   proxy_pass 'http://127.0.0.1:8080';
           }
  }'
   sudo ln -s /etc/nginx/sites-available/techascode /etc/nginx/sites-enabled/techascode
   sudo service nginx restart
}


installSSLCertificate() {
  echoMessage "${blue}" "Installing up SSL certificate"
  add-apt-repository ppa:certbot/certbot§ -y
  sudo apt-get update
  apt-get install python-certbot-nginx -y
  sudo certbot --nginx -n --agree-tos --email $email --redirect --expand -d $domainName -d $domainName2
  echoMessage "${green}" "Certificate installed successfuly"
}

start() {
  installCorePackages
  installNode
  cloneProject
  installDependencies
  installNginx
  installSSLCertificate
  buildApp
  processManager
}

start