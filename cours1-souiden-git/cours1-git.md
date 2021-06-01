vendredi 28 mai 2021 - Souiden cours1 -intervenant git -UE36 --distanciel
labynocle


https://docs.google.com/presentation/d/1_AxRyA-BxaqacAH-OsVIUtdZ8oW4Dv9ZuoYDiHdlbL0/edit#slide=id.g6c71ba4736_0_3
<p> ret</p>
Usage de git :

en quoi git est un scm particulier


travailler à plusieurs pour modifier facilement entre les collègues


dd


quel est le fichier le plus à jour par date de modification mais est-ce le bon fichier


on voit qui a modifié le fichier ls -al avec le nom d'user mais pas de garantie mais surtt pourquoi


collaboration pénible faire des diff des copies ...


merge fusionner les données actuelles et ceux des collègues 

la modification est stockée que par rapport aux diff


si c'est facile à utiliser de façon standard c'est complexe à maîtriser -> surtout pour un release manager (devops)


surtout au début

et le support de windows est difficile

beaucoup de gens de la communauté communique mal des commandes similaires - alternatives (à cause des permissions de fichiers par ex:)



man de git long et pas très bavard


go stackoverflow


il faut éviter de versionner des binaires / images / gros objets 
-> archive tar.gz de stopcovid 
pas de différence des tar.gz


explication contractuelle exposé le code de façon opensource mais le tar gz ne sert presque à rien ou mieux sur un ftp ou bucket_aws

pas de commit de secret sauf si chiffrée et sans clé de déchiffrement


git log pathtofile
ls -1al
ls -alh .git
éviter de modifier le répertoire .git mais surtout l''éditer via les commandes git

commit = historique d'un repo
git show nom_du_commit

:::image type="content" source="images/show.png" alt-text="show":::

- on voit :
    - que riadh a effcetué des modif sur le replica
        - et sur le fichier shaun par rapport au cpu

git plog


branche master -main


git branch -> courant d'en avoir plein 72 branches

:::image type="content" source="images/gitbranch.png" alt-text="gitbranch":::


usage de tag (pointeur) avec les SCM *un pointeur /marque-page vers un commit*

repo-commit-tag avec nimporte quel scm


git log


github = service d'hébergement

git rm



éviter d'avoir des messages peu compréhensible

git plog
:::image type="content" source="images/gitplog.png" alt-text="git plog":::



git checkout master


git pull


rancid

really awesome new cisco config differ

se connecte sur les équipements et les commit dans repo git pour automatiser les modifications  -> utilisé chez DEEZER


git plogfull


dnsmanager chez [gandi](https://www.gandi.net/fr) et avec jenkins avec une tâche CRON


