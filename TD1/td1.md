vendredi 28 mai 2021 - Augustin cours1 de TD 1 -UE36 --- Architecture d'un cloud provider --présentiel

## Architecture d'un cloud provider
#### LAN
1. Les 2 locataires ont la même adresse réseau interne.
2. La technique d'isolation sera des VLAN (trop de VLAN + de 4096 car codé sur 12 bits) ou des VPC : VxLAN (envoi en UDP des trames 802.1q VLAN)
3. Des trames de tous les VLAN doivent être taggées pour circuler entre l'hyperviseur et les équipements
    - SW1-SW2 :
        -  taggée
    - SWx-Hypx :
        - taggée
> [!TIP]
> Le port FA0/1 doit aussi être taggé
> Le PORT EST taggé si c'est avec un ID Vlan : 42 avec du 802.1q
> LAG chez HP ou port Trunk chez CISCO
> 
> - On peut faire un lien Trunk entre un switch et un routeur
>     - Trunk entre un switch et un pc    
>     - Trunk entre un switch et un switch    
> VLAN sans le 802.1q c'est possible mais très peu d'équipement
> Regrouper les vm sur le meme hyperviseur permet de gagner en terme de latence

4. Slide n°12 voir à la fin de la feuille (***recopier***)
5. La console peut accéder à l'interface d'administration des hyperviseurs car:
    - Même s'il n'est pas taggé
    - Ils sont dans le même réseau
    - VLAN natif - VLAN 1 (slide n°13) s'il n'est pas taggé le port et qu'il reçoit une trame taggée alors il ne reçoit qu'une trame non taggé
        - ICMP IP Ethernet seront encapsulé mais pas 802.1q
        - Console de gestion reçoit des trames non tagguées sur vlan 1 et envoie des trames non tagguées vers hypx
6. Dessiner voir au début de la feuille et un peu à la fin de la feuille (***recopier***)


#### hyperviseurs
7. On utilise le mode bridge car :
-  On a éliminée :
-  Réseau privée hôte 
    -  NAT
-  Seul qui permet de communiquer vers l'extérieure et adressage indépendante du réseau de l'hôte :    
    -  Accès par pont

8.  Voir feuille
- Le trafic que la VM reçoit comme trafic :
    - Conflit d'adresse IP car même vSwitch et 2 adresses IP identiques
    - La communication vers l'extérieur
- Pour y remédier nous allons utiliser des sous-interfaces. (slide n°4)
9. La technique utilisée pour garantir une isolation sont des sous-interfaces pour garantir l'isolation (on peut imbriquer des sous-interfaces avec 2 en-têtes 802.1q doubletagging)
10. Voir feuille  (***recopier***)


#### Routeur
11. L'interface FA0/23 sera en tant que port trunk en mode taggé
12. Combien de sous -interfaces = 1 sous interface par locataire  ici 3 sur fa0/1 
13. voir à la fin de la feuille  (***recopier***)
14. Voir WORD Selon sa table de routage VRF, elle ne voit pas les tables des autres clients VRF
15. Voir WORD
16.  voir feuille à la fin 192.168.1.1 associée à la sous-interface de délichoc : la passerelle de VM4 est 192.168.1.1
17.  La route doit être via un routage via R2 192.0.2.2 -- Voir WORD (slide n°17)
18. 
vrf = table de routage différent virtual routing and forwarding (slide n°17)

route leak = fuite de route : utilisée qq infos de la table principale dans une VRF1 table VRF secondaire



