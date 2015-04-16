#!/bin/bash
ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
COL_RED=$ESC_SEQ"31;01m"
COL_GREEN=$ESC_SEQ"32;01m"
COL_YELLOW=$ESC_SEQ"33;01m"
COL_BLUE=$ESC_SEQ"34;01m"
COL_MAGENTA=$ESC_SEQ"35;01m"
COL_CYAN=$ESC_SEQ"36;01m"

echo -e "$COL_YELLOW"
echo -e "################################################################################" 
echo -e "# Arrancador de proyectos!                                                     #"
echo -e "# Para hacer las cosas más simples                                             #"
echo -e "################################################################################" 
echo -e "$COL_RESET"


# Crea el workspace
read -r -p "Nombre del proyecto (se creará un directorio): " project_name

project_path=$(echo $project_name | tr " " "_" | tr A-Z a-z)
mkdir $project_path
cd $project_path


# Crea un virtualenv
read -r -p "Crear virtualenv? [y/N]: " ifyesno

if [[ $ifyesno =~ ^([yY][eE][sS]|[yY])$ ]]
then
    target=$(echo "env_$project_name" | tr " " "_" | tr A-Z a-z)
    virtualenv $target
    touch activateenv
    echo "source env_$project_name/bin/activate" >> activateenv 
    chmod +x activateenv

    echo -e "$COL_GREEN activando virtualenv....$COL_RESET"
    ./activateenv
fi


# Carga el repo si es necesario
echo -e "Hay repositorio? pegar URL (de clone): "
read -r -e url_repo

if [[ "$url_repo" ]]
then
    if [[ "$url_repo" == *.git ]]
    then
        git clone $url_repo repo
    else
        hg clone $url_repo repo
    fi
fi


# Instalar requirements.txt si es necesario
read -r -p "Instalar requirements.txt? ([N] para elegir common) [y/N]: " ifreq

if [[ $ifreq =~ ^([yY][eE][sS]|[yY])$ ]]
then
    pip install -r repo/requirements.txt
else
    read -r -p "Instalar common desde github.com/ninjaotoko/project_starter?: " ifyesno
    if [[ $ifyesno =~ ^([yY][eE][sS]|[yY])$ ]]
    then
        wget --no-check-certificate -O project_starter_requirements.txt https://raw.githubusercontent.com/ninjaotoko/project_starter/master/requirements.txt
        pip install -r project_starter_requirements.txt
    fi
fi

echo -e "$COL_GREEN Listo a divertirse \xF0\x9f\x8d\xba \xF0\x9f\x8d\xba!!! $COL_RESET"
