#/bin/bash

#git config --global user.name "Edisson Zuniga"
#git config --global user.email "edisson.zuniga@proveedor-credibanco.com"
#git config --list

git config --global core.autocrlf false

clear

# set variables
comment="${1}"
rama="${2}"

#Ayuda de Shell tagCreate
if [[ -z "$comment" || -z "$rama" ]]; # Si no se envia carpeta de repositorio de la aplicacion
    then
        echo  '-------------------------------------------------------------------------'
        echo  ' >>> Falta variable 1. commentario o nombre de la 2. rama >>>>           '
        echo  '-------------------------------------------------------------------------'
        exit 1
    else

        # Ejecucion
        git status
        read -p "Press [Enter] key to continue..." readEnterKey

        echo "----------------------------------------------------"
        echo "git add ."
        echo "----------------------------------------------------"
        git add .

        read -p "Press [Enter] key to continue..." readEnterKey

        echo "----------------------------------------------------"
        echo "git commit -m \"$comment\""
        echo "----------------------------------------------------"
        git commit -m "$comment"

        read -p "Press [Enter] key to continue..." readEnterKey

        echo "----------------------------------------------------"
        echo "git push origin $rama"
        echo "----------------------------------------------------"
        git push origin $rama

        read -p "Press [Enter] key to continue..." readEnterKey

fi