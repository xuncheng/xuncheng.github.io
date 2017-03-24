#!/bin/bash

# Decrypt the private key
openssl aes-256-cbc -K $encrypted_165796aad0fe_key -iv $encrypted_165796aad0fe_iv \
  -in .travis/deploy_rsa.enc -out ~/.ssh/deploy_rsa -d
# Set the permission of the key
chmod 600 ~/.ssh/deploy_rsa
# Start SSH agent
eval $(ssh-agent)
# Add the private key to the system
ssh-add ~/.ssh/deploy_rsa
# Copy SSH config
cp .travis/ssh_config ~/.ssh/config
# Set Git config
git config --global user.name "Xuncheng Wang"
git config --global user.email w.xun.cheng@gmail.com
# Clone the repository
git clone --branch master git@github.com:xuncheng/xuncheng.github.io.git .deploy_git
# Deploy to GitHub
npm run deploy
