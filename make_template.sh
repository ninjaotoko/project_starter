#!/bin/bash
################################################################################
# Este script busca en los *.html los comentarios marcados como:
# `<!-- block nombre_del_block -->` y lo transforma en block de templates django
#
# <!-- block nombre -->         {% block nombre %} 
# <!-- endblock nombre -->      {% endblock nombre %} 
# 
# <!-- insertblock nombre -->   {% block nombre %}
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
echo -e "# Creador de Templates para Django!                                            #"
echo -e "# Para hacer las cosas más simples                                             #"
echo -e "################################################################################" 
echo -e "$COL_RESET"


# Nombre para base.html
echo -e "Lo primero es crear el archivo theme_base.html, de aqui extienden los \n\
    demás.\n\
    $COL_RED""Hay que tener en cuenta que eliminara todo lo que esté dentro del\n\
    tag <main>, dejando solo <header> y <footer> más el parent <body>$COL_RESET\n\
    
    Estructura a crear:\n\
    <html>\n\
    <head>\n\
    </head>\n\
    <body>\n\
    <header>\n\
    ...\n\
    </header>\n\
    {% block main %}{% endblock %}
    <footer>\n\
    ...\n\
    </footer>\n\
    </body>\n\
    </html>"

echo -e "Luego se creará el archivo base.html que extiende de theme_base.html"

read -r -p "Nombre del archivo de cual se creará theme_base.html:" file_name

sed -e '
# Primero inserta el block entre header y footer
/<header>/ i\
    {% block main %}<!-- main -->{% endblock %}
# Elimina los tagas header y footer
/<header>/,/<\/footer>/ d
# Inserta en la primer linea los loads
1i \
{% load static %}{% spaceless %}
# Al final inserta el cierre de spaceless
$i \
{% endspaceless %}
# Elimina las doble lineas vacias
N; /^\n$/d; P; D
' <$file_name >theme_base.html

sed -n -e '
/<header>/,/<\/footer>/p
/<header>/ i\
    {% block header %}
/</header>/ i\
    {% endblock header %}
' 


sed -e '1i\
    {% load static %}' $file_name > theme_base.html

find . -name '*.html' -exec sed -i -e "s/<\!-- \([end]*\)block \([a-z_]*\) -->/{% \1block \2 %}/" {} \;

find . -name '*.html' -exec sed -i -e "s/<\!-- insertblock \([a-z_]*\) -->/{% include \"\1.html\" %}/" {} \;

find . -name '*.html' -maxdepth 1 -exec sed -i.bak -n -e '/<main>/,/<\/main>/p' {} \;
