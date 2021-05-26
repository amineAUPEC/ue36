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

`adduser etudiant`  
`usermod -aG sudo etudiant`  

`ufw app list`


```bash
ufw allow OpenSSH

ufw enable
ufw status
ssh etudiant@$IP
```


- installer apache

```bash
sudo apt update
sudo apt install apache2
sudo ufw app list
sudo ufw app info "Apache Full"
sudo ufw allow in "Apache Full"
ip addr show eth0 | grep inet | awk '{ print $2; }' | sed 's/\/.*$//'
```
*OR :*
```bash
sudo apt install curl
curl http://icanhazip.com
sudo apt install mysql-server
sudo mysql_secure_installation <<< "y"
sudo mysql
SELECT user,authentication_string,plugin,host FROM mysql.user;
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'password';
SELECT user,authentication_string,plugin,host FROM mysql.user;
exit
sudo apt install php libapache2-mod-php php-mysql

sudo cat > /etc/apache2/mods-enabled/dir.conf << EOF
<IfModule mod_dir.c>
    DirectoryIndex index.php index.html index.cgi index.pl index.xhtml index.htm
</IfModule>
EOF

sudo systemctl restart apache2
sudo systemctl status apache2

apt search php- | less
apt show package_name

apt show php-cli
sudo apt install php-cli

sudo mkdir /var/www/your_domain

sudo chown -R $USER:$USER /var/www/your_domain

sudo chmod -R 755 /var/www/your_domain
```


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




