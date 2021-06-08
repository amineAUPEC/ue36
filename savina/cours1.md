#### info :
cours 1 -- cert -- leonard savina  -- 10h05 -- 19 mai 2021  

## début
retex -> presentation du retour sur incident  ex: TV5 Monde, beaucoup d'autorisations à attendre


----------


la préparation - les contacts





-----------------


EDR = antivirus --> si en cas de crise, pas besoin de traiter le ticket lentement

-----------------

### la préparation - exercice

-----------------------------------
### la détection  - les types


- un incident commnece souvent par :
    1. les alarmes
    2. de l'équipe SOC via les SIEM
    3. un admin ou un user détecte l'anomalie
    1. un signalement d'un autre CERT
    1. ***
    
### la détection -le SOC



### la qualification

la qualification de l'incident savoir si l'incident est déjà connu ou pas 


> [!TIP]
> comme nom de code APT28 APT31  : mode opératoire Advanced Persistant Thread


### L'investigation
suite à cette qualification on va instiguer
- but:
    - voir le nombre d'appareils compromis
    - des tâches planifiées, à retirer
    - des IP, des marqueurs (IOCs) pour bloquer l'attaquant via les IDPS
    - définir les techniques, tactiques (TTPs)
    - établir une chronologie des actions menés par l'attaquant
    - trouver si
    - 
    - 
    - raison : VPN (avec que audit mdp ou token), phishing 
    - le patient 0 n'est pas forcément le + important

### la persistance
webshell -> envoyer une commande sur le serveur web en tant que root


### les marqueurs (IOCs) 
> [!NOTE]
> Indicator 
> marqueurs de compromission


réseau : adresse IP, nom


C2 : serveur de commande et de contrôle => serveur de l'attaquant *caché derrière des -> proxys pour anonymiser sa connexion*



### tactique (TTPs)


- reconnaisance : scan de ports
- ajout de compte
- RDP
- 
- MITRE attack

### block pyramidal

- TTPs
- IP -- easy to scan and to change
- hash -- trivial==easy
### endiquement
déconnecter les backups -- ransomware

réduire le taux d'incident

### remédiation
rotation des secrets --> *mot de passe ou accès -- login -- certificats*
corrigeant les vulnérabilités
malveillance interne -- une personne sabote le système


### EDR End point detection and response et la rémédiation
> [!NOTE]
> EDR End point detection and response


nouveau système d'antivirus


## intro à l'investigation numérique



### RETEX
avec les equipes FIRST, CERT



### histoire de l'investigation numérique

- créé par des policiers -- comme la FBI

- saisie de l'ordinateur pour savoir si on peut caractériser un crime

- de base n'avait pas été pratiqué par les CERT/CIRT


### les phases de l'investigation numérique



### les disciplines de l'investigation numérique
analyse forensique systèmes d'exploitation
analyse forensique équipements réseaux

-> analyste reverse seront appelés en renfort



### présentation de collecte

> [!WARNING]
>  on débranche le câble
collecte == récupération ou ne lit pas les données dans un premier temps

des infos volatiles : d'abord on les collecte mémoire vive - trafic réseau
des infos non volatiles : systèmes de fichiers, journaux déportés

dump de RAM


--> utilisé dd ou des binaires ou en lecture seule, rarement en écriture


### l'acquisition de la RAM
- avec des outils tiers  :
    - windows :
        - github winpmem 
        - microsoft debugger dump-create-dump-file
    - linux :
        - github microsoft avml  
        `dans le cas d'une VM en réalisant un snapshot complet de celle-ci`  

### la copie de disque
- copie de disque soit logiciel, soit matériel :
    - avec un copieur matériel
    - avec dd et mount en lecture seul
    - avec un bloqueur pour monter qu'en lecture
    - avec un live cd


-- si le disque est chiffré il faut la clé de déchiffrement
```powershell
    manage-bde -protectors C: -Get 
```

### outil de collecte

dfir-orc *outil de CSIRT, open-source*



### dfir-orc
récupération de tous les scripts

parser(traiter) 



### edr :
crowdstrike
fireye -- redline *standalone*



### flux réseau
capture pcap -- *wireshark* *thshark* *tcpdump*

pas le + discret avec ces 3 outils

mais sur le port mirroring, ou tiptap permet d'être + discret


##  l'analyse des collectes - principes généraux

### principe de l'analyse
l'ensemble des éléments collectés contient des artéfacts.

traitement de ces données

### les outils d'analyse
xway *chèr mais puissant*
logs -> SIEM
réseau


### marqueurs systèmes
- caractéristiques d'un marqueur :
    - nom du fichier
    - chemin complet
    - taille
    - condensat
- d'autres types de marqueurs
    - clef de registre
    - objet windows
    - MISP (CERT Luxembourg)

### chaînes de traitement d'analyse forensique == DFIR ANALYST 



### création de la chronologie
elle permet de détailler les actions malveillantes effectuées par l'attaquant sur le SI

## analyse des différentes collectes

### analyse de la mémoire vive
table des partition des inodes -- MFT *sous Windows*

### analyse de la mémoire vive - le dump
- type of dump
    - dump RAW
    - Full Crash dump
> padding == s'aligner en comblant, en rajoutant des données
### analyse de la mémoire vive - volativity
version python 2 + efficace


usage de cet outil volativity

> dump de processs pourquoi on le fait  
> on peut détecter le hooking   
> voir si le processus du gestionnaire de tâches n'est pas caché  

### limitations

on ne peut plus faire de dump de RAM avec les MAC 


clipos -- anssi

##  image de disque et son analyse


###  types d"images disque
convertir les images disques avec VMWARE vers VBOX ...

### l'accès aux données de l'image disque
`sudo fdisk -l`
`sudo mmls -t dos image.dd`
`sudo expr 273168 \* 512`
`sudo mount -t nfs-3g -o ro,loop,show,sys_files, offset=139862016 image.dd /mnt/ntfs`


### image disque Linux

ext2 ext4

table d'inode -- *visible en raw*
### image disque Windows
mft
### image disque Windows : MFT


### image disque Windows : MFT
`mmls image.dd`  
`fls -o 2048 -r -d image.dd`  
`istat -o 2048 image.dd 202854`  

--------------------------------
`dd if=image.dd of=sysmo64.exe bs=1 count=2500992 skip $((1005356 * 4096 + 2048 * 512))`  


-------------------------------
- Erase forcer :
    - shred *Linux*  
        efface le fichier et écris des 00 à la place
    
    - sdelete *Windows*
### evtx (Windows)



### registres Windows 
--------
- registres :
    - profil utilisateur
    - attaque de type run *par l'attaquant*
    - Shimcache, Amcache
### registre Amcache
anssi amcache
virustotal (votes, condensat et les antivirus *créé par Google*)

sha1-sum

### image disque windows : registres outils
Get-PsDrive, cd HKLM/

- artefacts :
    - fichiers prefetch
    - journal usn
    - fichiers de raccourci lnk
    - aretfacts de navigation web
### image disque windows : autres artefacts : PLASO (créé par Google)


Plaso en Python




## l'analyse par rétro-ingénierie : reverse engineering


### le reverse : intro
- prérequis  :
    - bonne base en assembleur  
    - savoir lire du code  
    - analyse PE  

---------------

obfuscation -- caché le code avec XOR  
CyberChef *créé par agence britanique*

### capture réseau : Netflows
- avantages:
    - retrouvé des adresses IP C2   
    - info de volumétrie


### capture réseau : OSINT
- base d'IP malveilante
    1. otx alienvault *gratuit*
    2. abuse ch
    3. rules emergingthreats net

- qualifier une IP
    1. ipinfo io
    2. shodan io
    
### analyse de journaux via Splunk
- Splunk :
    - Splunk cheatsheet



## mise en situation


### outils utilisés
- outils utilisés :
    - faille Sharepoint
    - reverse shell
    - cobalt strike **cs.exe**
    - outil de déploiement **psexec**
    - arrête l'Antivirus **stop.bat**
    - balance le ransomware


### collecte
- collecte :
    - réseau 
    - poste admin 
    - Sharepoint :
        - journaux webs
        - services
    - disque dur  
    - cs.exe
    - arrêt de services :
        - SQL
        - AD : 
            - mot de passe
            - dump des donnés 

### marqueurs
- marqueurs
    - ip
        - VPS1 
        - VPS2
    - outils
        - webshell
        - cs.exe
        - ransomware
        - psexec
    


### résolutions : Sharepoint
- Sharepoint en admin
    - patcher la faille 
    - Restreindre les connexions étrangères
- virer les outils webshell, cs.exe
- Admins :
    - modification des secrets administrateurs *avec des secrets différents*
    - arborescence des admins en tiers
    - bloquer DropBox depuis les serveurs DC



###### Notes :
> Dans 2 semaines le retour avec TP

> Sharepoint dans une DMZ parfois si pas d'authnetification externe 

### 


### 


### 

### 


### 


### 

### 


### 


### 

### 


### 


### 

### 


### 


### 

### 


### 


### 

### 


### 


### 

### 


### 


### 

### 


### 


### 

### 


### 


### 


