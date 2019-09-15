#!/bin/bash
# Ubuntu Panel [Server Manager] Installation
# Supported: Ubuntu 18.04 x86_64 LTS
# Default Installation :
# - Nginx Stable
# - PHP 7.2
#   - Composer Latest
#   - Laravel + Lumen
# - MariaDB 10.3
# - PhpMyAdmin Latest

## Check Distro Version
OSVERSION=$(grep "Ubuntu" "/etc/os-release")
if [ ! "$OSVERSION" ]; then
    echo "This script only for Ubuntu..!!!!"
    exit
fi

## Check User Owner
USEROWNER=$( whoami )
if [ "$USEROWNER" != "root" ]; then
    echo "Please change to root for continue installation..!!!!"
    exit
fi

## Update Repository
apt update
apt upgrade -y

# Install Nginx
apt install nginx -y
systemctl start nginx
systemctl enable nginx

# Install PHP 7.2 (Default)
PHPVERSION="7.2"
add-apt-repository ppa:ondrej/php
apt-get update
apt-get install php${PHPVERSION} \
                php${PHPVERSION}-cli \
                php${PHPVERSION}-mysqlnd \
                php${PHPVERSION}-mbstring \
                php${PHPVERSION}-curl \
                php${PHPVERSION}-zip \
                php${PHPVERSION}-xml \
                php${PHPVERSION}-fpm -y

# PHP Error Reporting Config
sed -i "s/error_reporting = .*/error_reporting = E_ALL/" /etc/php/${PHP_VERSION}/fpm/php.ini
sed -i "s/display_errors = .*/display_errors = On/" /etc/php/${PHP_VERSION}/fpm/php.ini

systemctl restart php${PHPVERSION}

# Added Laravel and Lumen
composer global require "laravel/installer"
composer global require "laravel/lumen-installer"

# Install Another Package
apt install wget \
            nano \
            git \
            curl -y

# Install Composer
cd /tmp
wget -4 https://getcomposer.org/installer
php installer --install-dir=/usr/bin --filename=composer
rm -rf installer

# Install WPCLI
wget -4 https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
mv wp-cli.phar /usr/bin/wp-cli
chmod +x /usr/bin/wp-cli