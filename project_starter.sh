#!/bin/bash
################################################################################
# Este script hace lo siguiente:
#
#   1- Crea una carpeta con el nombre del proyecto
#   2- Crea el env de python
#   3- Descarga el repo si fuese necesario
#   4- Instala con pip el requirements.txt del repo (si existe)
#   4.1- Si no, pregunta si queres instalar el common desde el repo
#   5- Crea la DB en mysql
#   6- Instala (syncdb o migrate) todo en la DB
#   7- Configura fabric
#
################################################################################

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
echo -e "Crendo directorio ./$project_path"
mkdir $project_path
cd $project_path


# Crea un virtualenv
read -r -p "Crear virtualenv? [y/N]: " ifyesno

if [[ $ifyesno =~ ^([yY][eE][sS]|[yY])$ ]]
then
    target=$(echo "env_$project_name" | tr " " "_" | tr A-Z a-z)
    virtualenv $target
    touch activate.sh
    echo "#!/bin/bash" >> activate.sh
    echo "source env_$project_name/bin/activate" >> activate.sh
    chmod +x activate.sh

    echo -e "$COL_GREEN"
    echo -e "activando virtualenv....$COL_RESET"
    source activate.sh
    pip freeze
fi


# Cargar template de proyecto
echo -e "$COL_GREEN"
echo -e "Crea la estructura del proyecto desde el template https://bitbucket.org/devlinkb/matriz $COL_RESET"
git clone https://bitbucket.org/devlinkb/matriz tmp

# Crea el enviroment para virtualenv
echo -e "$COL_GREEN"
echo -e "Crea el enviroment $COL_RESET"
pip install -r tmp/requirements.txt

echo -e "$COL_YELLOW"
echo -e "pip instaló$COL_RESET"
pip freeze

echo -e "Limpiando ... .git y otros temporales"
rm -rf tmp/.git
mv tmp/* .
rm -rf tmp

# Carga el repo si es necesario
echo -e "Hay repositorio creado para este proyecto? pegar URL (de clone): "
read -r -e url_repo

if [[ "$url_repo" ]]
then
    if [[ "$url_repo" == *.git ]]
    then
        git clone $url_repo repo
    else
        hg clone $url_repo repo
    fi

    if [ ! -f repo/requirements.txt ]
    then
        # Instalar requirements.txt si es necesario
        read -r -p "Instalar repo/requirements.txt del repositorio (si existe)? [y/N]: " ifreq

        if [[ $ifreq =~ ^([yY][eE][sS]|[yY])$ ]]
        then
            pip install -r repo/requirements.txt
        fi
    fi
else
    read -r -p "Iniciar versionado git? [y/N]: " ifreq

    # Crea el repo y hace commit inicial
    if [[ $ifreq =~ ^([yY][eE][sS]|[yY])$ ]]
    then
        mkdir repo
        cd repo
        git init
        read -r -p "Crear `origin`? git remote add origin (pegar url)" url_origin
        if [[ $url_origin ]]
        then
            git remote add origin $url_origin
            git add .
            git commit -m "init proyecto $project_name"
            git push -u origin master
        fi
    fi

    # Crea el proyecto de djagno
    django-admin.py $project_name
    mv ../local.py $project_name/

fi


# # Instalar paquetes commons
# read -r -p "Instalar common desde github.com/ninjaotoko/project_starter? [y/N]: " ifyesno
# 
# if [[ $ifyesno =~ ^([yY][eE][sS]|[yY])$ ]]
# then
#     wget --no-check-certificate -O project_starter_requirements.txt https://raw.githubusercontent.com/ninjaotoko/project_starter/master/requirements.txt
#     pip install -r project_starter_requirements.txt
# fi
# 
# echo -e "$COL_YELLOW"
# echo -e "pip instaló$COL_RESET"
# pip freeze


# Crear Mysql
read -r -p "Crear base en MySQL? [y/N]: " ifreq

if [[ $ifreq =~ ^([yY][eE][sS]|[yY])$ ]]
then

    read -r -p "Usar nombre de proyecto para DB ($project_name""_db)? [y/N]: " ifreq
    if [[ $ifreq =~ ^([yY][eE][sS]|[yY])$ ]]
    then
        database_name=$(echo $project_name"_db")
    else
        read -r -p "Escribir nombre de DB para el proyecto (ej: $project_name""_db): " database_name
    fi

    read -r -p "Usar 'dev'@'localhost' para permisos de DB [y/N]: " ifreq
    if [[ $ifreq =~ ^([yY][eE][sS]|[yY])$ ]]
    then
        user_permission="'dev'@'localhost'"
    else
        read -r -p "Escribir 'usuario' y 'host' con comillas para permisos de DB (ej 'dev'@'localhost'): " user_permission
    fi
    
    echo "CREATE DATABASE $database_name; GRANT ALL ON $database_name.* TO $user_permission;" | sudo mysql
fi


# Crear local.py para proyecto Django
read -r -p "Crear local.py para proyecto Django [y/N]: " ifreq

if [[ $ifreq =~ ^([yY][eE][sS]|[yY])$ ]]
then

    if [[ !$database_name ]]
    then
        read -r -p "Nombre de la base de datos: " database_name
    fi

    if [[ !$database_user ]]
    then
        read -r -p "Nombre de usuario de la base de datos: " database_user
    fi

    if [[ !$database_pass ]]
    then
        read -r -p "Password de la base de datos: " database_pass
    fi

    if [[ !$database_host ]]
    then
        read -r -p "Host para conectar la base de datos (opcional):  " database_host
    fi

    #wget --no-check-certificate -O - https://raw.githubusercontent.com/ninjaotoko/project_starter/master/local.py  \
    #    sed -e "s/\${database_name}/"$database_name"/" \
    #    -e "s/\${database_user}/"$database_user"/" \
    #    -e "s/\${database_pass}/"$database_pass"/" \
    #    -e "s/\${database_host}/"$database_host"/" \
    #    > local.py

    cat ../local.py sed -e "s/\${database_name}/"$database_name"/" \
        -e "s/\${database_user}/"$database_user"/" \
        -e "s/\${database_pass}/"$database_pass"/" \
        -e "s/\${database_host}/"$database_host"/" \
        > $project_name/local.py

fi

# # Preparar local con fabric
# read -r -p "Ejecutar fabric prepare_local? [y/N]: " ifreq
# 
# if [[ $ifreq =~ ^([yY][eE][sS]|[yY])$ ]]
# then
# 
#     if [[ "$url_repo" ]]
#     then
#         cd repo
#         fab prepare_local
#     fi
# fi

# Crea los estaticos
echo -e "$COL_GREEN"
echo -e "Crea el proyecto de foundation$COL_RESET"
foundation new $project_name/assets


echo -e "Para comenzar ejecuta $COL_MAGENTA source activate.sh$COL_RESET"
echo -e "$COL_GREEN"
echo -e "Listo a divertirse \xF0\x9f\x8d\xba \xF0\x9f\x8d\xba $COL_RESET"
echo -e ""
