

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
        "builders": [
            type: "virtualbox-ovf",
            source_path: "/home/etudiant/debian-stretch.ova",
            ssh_username: "root",
            ssh_password: "vitrygtr",
            vm_name: "fw",
            vboxmanage: "************",
            vboxmanage_post: "************"
        
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




- Configuration en adressage persistant des cartes-réseaux
> [!WARNING]
> Ici copier ce fichier vers le dossier app
`cp interfaces /home/etudiant/app/fw/etc/network/`

```json
    {
         "type": "file",
         "source": "/home/etudiant/app/fw/etc/network/interfaces",
         "destination": "/etc/network/interfaces"
    }
```

- ajouter à git :
```bash
cd ..
git add fw/etc/network/interfaces
git commit fw/etc/network/interfaces <<< "Fichier_interfaces_fw"
git push origin master
```

- renommer la VM
    - 1ère étape : édit avec hostnamectl
        ```json
            {
                "type": "shell",
                "inline": ["hostnamectl set-hostname fw "]
            }
        ```

    - 2ème étape : remplacement du fichier /etc/hosts
        ```json
                {
                 "type": "file",
                 "source": "/home/etudiant/repo/fw/etc/hosts",
                 "destination": "/etc/hosts "
                }
        ```
    - 3 ème étape : reboot    
            ```json
            {
                "type": "shell",
                "inline": ["reboot"]
            }
        ```