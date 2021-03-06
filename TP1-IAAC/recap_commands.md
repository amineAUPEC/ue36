

- DL ova from iut_ftp in /home/etudiant
### 2.2 Serveur Git :
- DL id_rsa from prof_web_server
`cp id_rsa to .ssh`

- Cloner le depot :

`git clone $ip:app.git`  
`cd app`  
`cat exemple/*`  

`cd fw`

- Infos ![Warning] Vous ne devez pas toucher aux autres dossiers (c'est le travail de vos collègues) 
    ```yaml
        fw fw.sh Active le filtrage de trafic avec iptables
        lb haproxy.cfg Configure haproxy pour répartir la charge 
        sur les deux serveurs Web
        www1
        www2
        index.php Code PHP du site Web
        mysql app.sql Crée et initialise la base de données
        log monitor.sh Supervise les serveurs Web
        ```



- Personnaliser la conf git : modifier name et mail
`git config --global --edit`

- Créer le fichier json
`touch fw.json`

- Ajouter à git :
```bash
cd ..
git add fw/fw.json
git commit fw/fw.json <<< "Création du fichier de conf Packer"
git push origin master
```

- pull (synchro) git :
`git pull`

- Voir les contributions 
`git log`

- Packer
    - Comprendre la syntaxe , rôle d'un builder et des provisionners  
`cat exemple/dns.json`  


- Packer builder :
```json
    {
        "builders": [{
            "type": "virtualbox-ovf",
            "source_path": "/home/etudiant/debian-stretch.ova",
            "ssh_username": "root",
            "ssh_password": "vitrygtr",
            "vm_name": "fw",
            "vboxmanage": "************",
            "vboxmanage_post": "************"
        }
      ]
    }
```

- Démo pour afficher l'utilisateur et une adresse IP via un provisionner :
```json
    {
      "type": "shell",
      "inline": ["whoami && ip a"]
    }

```

- Construire une VM via Packer :
    - Démo du prof :
        ```bash
        packer validate exemple/dns.json
        packer build exemple/dns.json
        ```
    -  Démo avec fw.json

        ```bash
        packer validate fw/fw.json
        packer build fw/fw.json
        ```

- commit et push :
`git pull`  
`git commit -a`  
`git push`  
***OR***
*Il est souvent recommandé de faire git add . pour ajouter les fichiers*
`git add .`
`git commit -m "fw_init_partie3_1"`
`git push`

- recommencez :
- Si fw :
`sudo VboxManage unregistervm fw --delete`
`sudo rm -rf fw/output-virtualbox-ovf/`


- Configuration en adressage persistant des cartes-réseaux
> [!WARNING]
> Ici copier ce fichier vers le dossier app
`cp interfaces /home/etudiant/app/fw/etc/network/`
*Son contenu*:
```bash
auto eth0
iface eth0 inet static
    address /24
```
```json
    {
         "type": "file",
         "source": "/home/etudiant/app/fw/etc/network/interfaces",
         "destination": "/etc/network/interfaces"
    }
```

- Ajouter à git :
```bash
cd ..
git add fw/etc/network/interfaces
git commit fw/etc/network/interfaces <<< "Fichier_interfaces_fw"
git push origin master
```

- Renommer la VM
    - 1ère étape : Édit avec hostnamectl
        ```json
            {
                "type": "shell",
                "inline": ["hostnamectl set-hostname fw"]
            }
        ```

    - 2ème étape : Remplacement du fichier /etc/hosts
        ```json
                {
                    "type": "file",
                    "source": "/home/etudiant/repo/fw/etc/hosts",
                    "destination": "/etc/hosts"
                }
        ```
    - 3 ème étape : reboot    
        ```json
            {
                "type": "shell",
                "inline": ["reboot"]
            }
        ```
- Installation des paquets :
- Si fw :
    ```json
        {
            "type": "shell",
            "inline": ["apt-get update –y && apt-get install –y tcpdump"]
        }
    ```
- Si lb :
    ```json
        {
            "type": "shell",
            "inline": ["apt-get update –y && apt-get install –y haproxy"]
        }
    ```
- Si www1 :  
    ```json
        {
            "type": "shell",
            "inline": ["apt-get update –y && apt-get install –y apache2"]
        }
    ```
- Si www2 :  
    ```json
        {
            "type": "shell",
            "inline": ["apt-get update –y && apt-get install –y php7-0 php7.0-mysql"]
        }
    ```
- Si mysql :  
    ```json
        {
            "type": "shell",
            "inline": ["apt-get update –y && apt-get install –y mysql-server"]
        }
    ```
- Si log :  
    ```json
        {
            "type": "shell",
            "inline": ["apt-get update –y && apt-get install –y beep"]
        }
    ```

- Construire une VM
    -  Démo avec fw.json

        ```bash
        packer validate fw/fw.json
        packer build fw/fw.json
        ```

        ```bash
        packer validate ./scripts/provisionner_ip_whoami.json
        packer build ./scripts/provisionner_ip_whoami.json        

        packer validate ./scripts/fw/hostnamectl.json
        packer build ./scripts/fw/hostnamectl.json


        packer validate ./scripts/fw/hosts.json
        packer build ./scripts/fw/hosts.json

        packer validate ./scripts/fw/reboot.json
        packer build ./scripts/fw/reboot.json


        packer validate ./scripts/fw/paquetages.json
        packer build ./scripts/fw/paquetages.json
        ```    

    -  Démo avec lb.json

        ```bash
        packer validate lb/lb.json
        packer build lb/lb.json
        ```

        ```bash
        packer validate ./scripts/provisionner_ip_whoami.json
        packer build ./scripts/provisionner_ip_whoami.json        

        packer validate ./scripts/lb/hostnamectl.json
        packer build ./scripts/lb/hostnamectl.json


        packer validate ./scripts/lb/hosts.json
        packer build ./scripts/lb/hosts.json

        packer validate ./scripts/lb/reboot.json
        packer build ./scripts/lb/reboot.json


        packer validate ./scripts/lb/paquetages.json
        packer build ./scripts/lb/paquetages.json
        ```
    -  Démo avec www1.json

        ```bash
        packer validate www1/www1.json
        packer build www1/www1.json
        ```

        ```bash
        packer validate ./scripts/provisionner_ip_whoami.json
        packer build ./scripts/provisionner_ip_whoami.json        

        packer validate ./scripts/www1/hostnamectl.json
        packer build ./scripts/www1/hostnamectl.json


        packer validate ./scripts/www1/hosts.json
        packer build ./scripts/www1/hosts.json

        packer validate ./scripts/www1/reboot.json
        packer build ./scripts/www1/reboot.json


        packer validate ./scripts/www1/paquetages.json
        packer build ./scripts/www1/paquetages.json
        ```
    -  Démo avec www2.json

        ```bash
        packer validate www2/www2.json
        packer build www2/www2.json
        ```

        ```bash
        packer validate ./scripts/provisionner_ip_whoami.json
        packer build ./scripts/provisionner_ip_whoami.json        

        packer validate ./scripts/www2/hostnamectl.json
        packer build ./scripts/www2/hostnamectl.json


        packer validate ./scripts/www2/hosts.json
        packer build ./scripts/www2/hosts.json

        packer validate ./scripts/www2/reboot.json
        packer build ./scripts/www2/reboot.json


        packer validate ./scripts/www2/paquetages.json
        packer build ./scripts/www2/paquetages.json
        ```
    -  Démo avec mysql.json

        ```bash
        packer validate mysql/mysql.json
        packer build mysql/mysql.json
        ```

        ```bash
        packer validate ./scripts/provisionner_ip_whoami.json
        packer build ./scripts/provisionner_ip_whoami.json        

        packer validate ./scripts/mysql/hostnamectl.json
        packer build ./scripts/mysql/hostnamectl.json


        packer validate ./scripts/mysql/hosts.json
        packer build ./scripts/mysql/hosts.json

        packer validate ./scripts/mysql/reboot.json
        packer build ./scripts/mysql/reboot.json


        packer validate ./scripts/mysql/paquetages.json
        packer build ./scripts/mysql/paquetages.json
        ```
    -  Démo avec log.json

        ```bash
        packer validate log/log.json
        packer build log/log.json
        ```

        ```bash
        packer validate ./scripts/provisionner_ip_whoami.json
        packer build ./scripts/provisionner_ip_whoami.json        

        packer validate ./scripts/log/hostnamectl.json
        packer build ./scripts/log/hostnamectl.json


        packer validate ./scripts/log/hosts.json
        packer build ./scripts/log/hosts.json

        packer validate ./scripts/log/reboot.json
        packer build ./scripts/log/reboot.json


        packer validate ./scripts/log/paquetages.json
        packer build ./scripts/log/paquetages.json
        ```


## synth1 fin :

- activer le routage sur fw :  
- copie du fichier en local :  
`cp ./fw/etc/network/routing.sh /home/etudiant/app/fw/`
*Son contenu* :  
```bash
sed -E -i.SAVE \
's/^net.ipv4.ip_forward/#net.ipv4.ip_forward/' \
/etc/sysctl.conf
```
- copie du script (fichier) sur la VM dans */root*
```json
    {
        "type": "file",
        "source": "/home/etudiant/app/fw/routing.sh ",
        "destination": "/root/routing.sh"
    }

```
- Exécution du script :
```json
    {
        "type": "shell",
        "inline": ["cd /root && chmod +x routing.sh && ./routing.sh"]
    }
```

