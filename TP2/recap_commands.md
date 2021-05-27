### 2. Configuration du VPC :
#### Préparation
1. Dans une connexion SSH, le rôle du fichier id_rsa : elle sert de clé privée, c'est l'équivalent de la serrure qui forme le couple avec sa clé qui est dédiée dans notre cas elle correspond à la clé publique id_rsa.pub

2. Le NAT statique : correspond à la translation d'une adresse IP publique par une adresse IP privée (*à vérifier*)

3. Le port TCP par défaut pour le protocole SSH est le port 22.

#### Mise en place de l'architecture :

- Authentification par clé publique :
    - Générer le couple de clé depuis l'interface EC2 en créant l'instance t2.micro
    - Récupérer la clé publique et se placer dans ce dossier `cd $folder`  
    `ssh -i *.pem ubuntu@$IP`
- digitalocean à configurer ou lancer le script du prof :
[digitalocean](https://www.digitalocean.com/community/tutorials/how-to-install-and-configure-owncloud-on-ubuntu-18-04)

- créer user avec sudo
- activer le firewall

`sudo adduser etudiant`  
`sudo usermod -aG sudo etudiant`  
- *optionnel or in AWS EC2 FIREWALL INTERFACE BEGIN*
`ufw app list`


```bash
ufw allow OpenSSH

ufw enable
ufw status
ssh etudiant@$IP
```

- *optionnel or in AWS EC2 FIREWALL INTERFACE END*

`sudo rsync --archive --chown=etudiant:etudiant ~/.ssh /home/etudiant`

`su etudiant`
`ssh -i ssh-web.pem etudiant@$IP`

- installer apache

```bash
sudo apt update -y
sudo apt install apache2 -y
# - *optionnel or in AWS EC2 FIREWALL INTERFACE BEGIN*
sudo ufw app list
sudo ufw app info "Apache Full"
sudo ufw allow in "Apache Full"
# - *optionnel or in AWS EC2 FIREWALL INTERFACE END*
ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
```
*OR :*
```bash
sudo apt install curl
curl http://icanhazip.com
sudo apt install mysql-server -y
sudo mysql_secure_installation 
# <<< "y"
sudo mysql
SELECT user,authentication_string,plugin,host FROM mysql.user;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password*1A';
SELECT user,authentication_string,plugin,host FROM mysql.user;
exit
sudo apt install php libapache2-mod-php php-mysql -y

sudo -i
sudo cat > /etc/apache2/mods-enabled/dir.conf << EOF
<IfModule mod_dir.c>
    DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>
EOF
exit

sudo systemctl restart apache2
sudo systemctl status apache2

apt search php- | less
apt show package_name

apt show php-cli
`sudo apt install php-cli -y`

# *optionnel BEGIN*

sudo mkdir /var/www/your_domain

sudo chown -R $USER:$USER /var/www/your_domain

sudo chmod -R 755 /var/www/your_domain
# *optionnel  END*
# *optionnel BEGIN*
# *optionnel END*

```

- sans domaine avec certificat autosignée
```bash
sudo -i
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/ssl/private/apache-selfsigned.key -out /etc/ssl/certs/apache-selfsigned.crt << EOF
FR
Paris
Paris
AugustinCorp Inc
AugustinCorp
54.235.8.226 
zemail@u-pec.fr
EOF
exit
```

```bash
sudo -i
sudo cat > /etc/apache2/conf-available/ssl-params.conf << EOF
SSLCipherSuite EECDH+AESGCM:EDH+AESGCM:AES256+EECDH:AES256+EDH
SSLProtocol All -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
SSLHonorCipherOrder On
# Disable preloading HSTS for now.  You can use the commented out header line that includes
# the "preload" directive if you understand the implications.
# Header always set Strict-Transport-Security "max-age=63072000; includeSubDomains; preload"
Header always set X-Frame-Options DENY
Header always set X-Content-Type-Options nosniff
# Requires Apache >= 2.4
SSLCompression off
SSLUseStapling on
SSLStaplingCache "shmcb:logs/stapling-cache(150000)"
# Requires Apache >= 2.4.11
SSLSessionTickets Off
EOF
exit
```

`sudo cp /etc/apache2/sites-available/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf.bak`  
`sudo nano /etc/apache2/sites-available/default-ssl.conf`  

> 
    <IfModule mod_ssl.c>
            <VirtualHost _default_:443>
                    ServerAdmin your_email@example.com
                    ServerName server_domain_or_IP
    
                    DocumentRoot /var/www/html
    
                    ErrorLog ${APACHE_LOG_DIR}/error.log
                    CustomLog ${APACHE_LOG_DIR}/access.log combined
    
                    SSLEngine on
    
                    SSLCertificateFile      /etc/ssl/certs/apache-selfsigned.crt
                    SSLCertificateKeyFile /etc/ssl/private/apache-selfsigned.key
    
                    <FilesMatch "\.(cgi|shtml|phtml|php)$">
                                    SSLOptions +StdEnvVars
                    </FilesMatch>
                    <Directory /usr/lib/cgi-bin>
                                    SSLOptions +StdEnvVars
                    </Directory>
    
            </VirtualHost>
    </IfModule>


`sudo nano /etc/apache2/sites-available/000-default.conf` 
>
    Redirect permanent "/" "https://your_domain_or_IP/"
    Redirect permanent "/" "https://54.235.8.226/"

54.235.8.226
```bash
sudo a2enmod ssl
sudo a2enmod headers


sudo a2ensite default-ssl


sudo apache2ctl configtest
sudo systemctl restart apache2


```



- installation d'own cloud
`curl https://download.owncloud.org/download/repositories/10.0/Ubuntu_18.04/Release.key | sudo apt-key add -`  
`curl https://attic.owncloud.org/download/repositories/10.0/Ubuntu_18.04/Release.key | sudo apt-key add -`  

`echo 'deb http://download.owncloud.org/download/repositories/10.0/Ubuntu_18.04/ /' | sudo tee /etc/apt/sources.list.d/owncloud.list`


```bash
sudo apt update -y
sudo apt install php-bz2 php-curl php-gd php-imagick php-intl php-mbstring php-xml php-zip owncloud-files -y
```



`sudo apache2ctl -t -D DUMP_VHOSTS | grep server_domain_or_IP`
`sudo apache2ctl -t -D DUMP_VHOSTS | grep 54.235.8.226`


<!-- `sudo nano /etc/apache2/sites-enabled/server_domain_or_IP.conf` -->
`sudo nano /etc/apache2/sites-available/000-default.conf`
`sudo nano /etc/apache2/sites-available/default-ssl.conf`

<!-- `sudo nano /etc/apache2/sites-enabled/000-default.conf`
`sudo nano /etc/apache2/sites-enabled/ssl.conf` -->

`sudo apache2ctl configtest`

`sudo systemctl reload apache2`


`sudo mysql -p`

`CREATE DATABASE owncloud;`

`GRANT ALL ON owncloud.* to 'owncloud'@'localhost' IDENTIFIED BY 'owncloud_database_password';`
kill privileges
`exit`


................................

- Création du serveur git :
[create git serv](http://www.qanuq.com/2017/10/10/creer-serveur-git/)  
`git init --bare /home/etudiant/monprojet.git`  
`git clone etudiant@$IPlocal:/home/etudiant/monprojet.git`

`cd monprojet/`  
`cd projet/`
###### Initialisation du dépôt local dans le dossier courant
`git init`

###### Ajout des sources
`git add .`

###### Premier commit
`git commit -m "premier commit"`

###### Mise en place du lien vers le dépôt distant
`git remote add origin etudiant@$IPlocal:/home/etudiant/monprojet.git`

###### Push vers le dépôt distant
`git push --set-upstream origin master`
###### À ne faire qu'une seule fois
`sudo bash -c "echo $(which git-shell) >> /etc/shells"`
`sudo chsh --shell $(which git-shell) etudiant`
###### Création du groupe gitusers
`groupadd gitusers`


######  user pouvant accéder au dépôt  
`usermod -a -G gitusers etudiant`  
`usermod -a -G gitusers paul`  
`usermod -a -G gitusers jacques`  



###### Création du répertoire /git
`sudo mkdir /git`
###### Son propriétaire a tous les droits, le groupe a juste le droit d'y entrer
`sudo chmod 710 /git`

###### On ajoute le setgid sur le répertoire. ainsi, tous les sous répertoires
###### Seront aussi du groupe gitusers
`sudo chmod g+ws /git`

###### root est le propriétaire, gitusers le groupe
`sudo chown root:gitusers /git`

###### on initialise un dépôt --bare en précisant qu'on le partage via le groupe
`sudo git init --bare --shared=group /git/monprojet.git`




## synth1 fin :



- Installer CLI AWS :
`sudo apt-get update -y && apt-get install python3 python python3-pip`  
`sudo pip install awscli`
`sudo pip3 install awscli`


- configurer la connexion au compte aws :
- Consulter la documentation d'Amazon :  
[docsaws](https://docs.aws.amazon.com/fr_fr/cli/latest/userguide/cli-services-ec2-instances.html)  

- Commandes aws ec2 usuelles :
    - `run-instances`
    - `terminate-instances`
    - `describe-instances`
    
- Configuration du firewall AWS en CLI :

```bash
# Renvoie l'identifiant du security group (sg-*)
# associé à l'instance (dont l'identifiant 
# est $INSTANCE_ID) 
aws ec2 describe-instance-attribute \
--instance-id $INSTANCE_ID \
--attribute groupSet
# Ajoute une règle dans le security group $SG_ID
# pour autoriser les connexions TCP sur le port 4242 
# de l'instance, depuis n'importe où. 
aws ec2 authorize-security-group-ingress \
--group-id $SG_ID \
--protocol tcp --port 4242 --cidr 0.0.0.0/0
```

Voir l'historique des commandes depuis l'interface aws et exécuté les commandes ou alors history puis exécuter les commandes
## synth2 fin :


[aws_credentials](https://www.packer.io/docs/builders/amazon.html#specifying-amazon-credentials)
./docs/ec2_modified.json  
son contenu :
```json
{
    "builders": [
    {
        "type": "amazon-ebs",
        "region": "us-east-1",
        "source_ami": "ami-fce3c696",
        "instance_type": "t2.micro",
        "ssh_username": "ubuntu",
        "ami_name": "Ta meilleure AMI",
        "access_key": "AKIAIOSFODNN7EXAMPLE",
        "secret_key": "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"

    }
    ]
}
```
## synth3 fin :
