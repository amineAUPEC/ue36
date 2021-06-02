#!/bin/bash

# Installation MINIMALISTE d'un serveur ownCloud sur une instance AWS EC2 Ubuntu 18.04 LTS
# NE PAS UTILISER EN PROD !
# Basé sur l'excellent tutorial de Digital Ocean :
# https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-owncloud-on-ubuntu-18-04

VMIP=$(curl http://api.ipify.org)

# Créer un utilisateur avec les privilèges sudo
# Pas indispensable

# Activer le firewall
# Pas indispensable

# Installer Apache
apt update -y
apt install -y apache2

# Autoriser le trafic Web dans le firewall
# Pas indispensable

# Installer un serveur de base de données MySQL
apt install -y mysql-server

# Sécuriser le serveur MySQL
# Pas indispensable

# Installer PHP
apt install -y php libapache2-mod-php php-mysql

sed -i '/DirectoryIndex /s/index.php //' /etc/apache2/mods-enabled/dir.conf

sed -i 's/DirectoryIndex /DirectoryIndex index.php /' /etc/apache2/mods-enabled/dir.conf

# Redémarrer le service Apache
systemctl restart apache2

# Installer des modules optionnels pour PHP
# Pas indispensable

# Vérifier que PHP fonctionne bien sur le serveur
# Pas indispensable

# Créer un certificat SSL associé à un nom de domaine
# Pas indispensable

# Créer un certificat SSL sans nom de domaine
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt -subj "/C=FR/ST=Vitry/L=Vitry/O=Goldorak CA/OU=Green Lantern sux/CN=$VMIP"

# Renforcer la sécurité d’Apache avec une suite cryptographique forte
# Pas indispensable

# Modifier le VirtualHost pour activer SSL
sed -i "/ServerAdmin /a\           ServerName $VMIP" /etc/apache2/sites-available/default-ssl.conf
sed -i 's/ssl-cert-snakeoil.pem/apache-selfsigned.crt/' /etc/apache2/sites-available/default-ssl.conf

sed -i 's/ssl-cert-snakeoil.key/apache-selfsigned.key/' /etc/apache2/sites-available/default-ssl.conf

# Rediriger le trafic non chiffré vers HTTPS
# Pas indispensable

# Autoriser le trafic HTTPS dans le firewall
# Pas indispensable

# Activer les changements dans Apache
a2enmod ssl
a2ensite default-ssl

systemctl restart apache2

# Vérifier que le chiffrement est bien activé
# Pas indispensable

# Forcer la redirection du trafic non chiffré vers HTTPS
# Pas indispensable

# Installer ownCloud
# 05/2021 : -L pour suivre la redirection (Moved Permanently)
curl -L https://download.owncloud.org/download/repositories/10.0/Ubuntu_18.04/Release.key | sudo apt-key add -

echo 'deb http://download.owncloud.org/download/repositories/10.0/Ubuntu_18.04/ /' | sudo tee /etc/apt/sources.list.d/owncloud.list

apt update -y

apt install -y php-bz2 php-curl php-gd php-imagick php-intl php-mbstring php-xml php-zip owncloud-files

# -i Marche pas quand lancé avec sudo !!! Pourquoi ??? Trop bizarre (2019, 2021)
# Lien symbolique ?? Mais pourquoi les sed précédents auraient fonctionné ?
# Faire pointer le DocumentRoot sur le dossier d’ownCloud
sed -E 's/^\s+DocumentRoot\s.*/       DocumentRoot \/var\/www\/owncloud/' /etc/apache2/sites-enabled/default-ssl.conf > tmp
cp tmp /etc/apache2/sites-enabled/default-ssl.conf
rm tmp

systemctl reload apache2

# Configurer la base de données MySQL
cat > config.sql << EOF
CREATE DATABASE owncloud;
GRANT ALL ON owncloud.* to 'owncloud'@'localhost' IDENTIFIED BY 'vitrygtr';
FLUSH PRIVILEGES;
EOF

mysql < config.sql

# Configurer ownCloud
# Le reste se passe dans le navigateur !
