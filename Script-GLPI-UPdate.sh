#!/bin/sh
 
# Suppression des fichiers de la mise à jour précédente qui peuvent perturber le script
echo 'Nous supprimons tous les fichiers dans /tmp avec \"glpi\" dedans qui peuvent perturber le script.'
rm -RI /tmp/*glpi*
 
# Règlement des variables pour la mise à jour.
read -p 'Entrez le chemin de actuel GLPI(example: /var/www/html/glpi):' glpi
 
# Aller dans le répertoire
#echo 'Aller dans le répertoire'
#cd /tmp
 
# Sauvegarde du glpi et de la base de données
echo 'Nous sauvegardons les fichiers et la base de données'
cp -R $glpi /tmp/glpibackup
read -p 'Fichiers sauvegardés. Quel est le nom de votre base de données GLPI ?' db
read -p 'Qui est le propriétaire de votre base de données glpi?' user
read -s -p 'Quel est le mot de passe du propriétaire de votre base de données glpi ?' passwd
mysqldump -u $user -p$passwd $db > /tmp/$db'save'.sql
echo 'OK'
 
# Lien de Téléchargement
#Exemple GLPI -V 9.5.7 ===> wget https://github.com/glpi-project/glpi/releases/download/9.5.7/glpi-9.5.7.tgz
read -p 'Entrer le lien de téléchargement:' link
wget $link    
echo 'Downloaded'

# OCS Inventory Server
#Exemple OCS Inventory ===> wget https://github.com/OCSInventory-NG/OCSInventory-ocsreports/releases/download/2.9.2/OCSNG_UNIX_SERVER-2.9.2.tar.gz
read -p 'Entrer le lien de téléchargement:' link
wget $link    
echo 'Downloaded'


# Plugins Fusion Téléchargement
#Exemple Fusion ===> wget https://github.com/fusioninventory/fusioninventory-agent/releases/download/2.6/fusioninventory-agent_2.6-1_all.deb
read -p 'Entrer le lien de téléchargement:' link
wget $link    
echo 'Downloaded'


# extraction puis suppression d'archives
echo 'Extraction puis suppression archive'
tar -zxf glpi*.tgz -C /tmp
rm /tmp/glpi*.tgz
echo 'OK'
 
# Suppression du dossier de fichiers dans le nouveau glpi
echo 'Maintenant nous supprimons le dossier des fichiers du nouveau GLPI'
rm -RI /tmp/glpi/files
echo 'OK'
 
# Déplacement de l'ancien glpi dans le répertoire de travail + renommage
echo 'Nous déplaçons le glpi in-prod dans le dossier de travail'
mv $glpi /tmp/glpi_old
echo 'OK'
 
# Nettoyage des anciens "fichiers" de glpi
echo 'Nous allons maintenant nettoyer le dossier et fichiers'
rm -RI /tmp/glpi_old/files/_*/*
 
# Copie des fichiers qui sont dans prod dans glpi
echo 'Ensuite, nous copions le dossier des fichiers in-prod et le fichier de configuration de la base de données dans le nouveau glpi'
cp -R /tmp/glpi_old/files /tmp/glpi/
cp /tmp/glpi_old/config/config_db.php /tmp/glpi/config/
echo 'OK'
 
# Déplacement du nouveau glpi dans le dossier web
echo 'Nous supprimons les anciens glpi'
rm -RI /tmp/glpi_old
echo 'OK'
 
echo 'Nous déplaçons le nouveau glpi dans le dossier web'
mv /tmp/glpi $glpi
echo 'OK'
 
# Règles du propriétaire + droits
echo 'Nous établissons les droits et le propriétaire'
read -p 'Utilisateur web ? (example: apache)' webuser
read -p 'Groupe web ? (example: apache)' webgroup
chown -R $webuser:$webgroup $glpi
chmod -R 770 $glpi
find $glpi -type d -exec chmod 750 {} \;
find $glpi -type f -exec chmod 740 {} \;
echo 'OK'
 
echo 'La mise à jour est presque terminée. Connectez-vous maintenant à interface web pour continuer. See Uu ;) '
