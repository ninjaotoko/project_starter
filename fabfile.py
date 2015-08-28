# -*- coding:utf-8 -*-

from __future__ import with_statement
from fabric.api import * #local, settings, abort, run, cd, prefix
from fabric.contrib.console import confirm

#env.hosts = ['devlinkb2']
env.host_string = 'xavier@devlinkb2:31755'
env.base_projects = '/var/www/apps/'
env.project_path = env.base_projects + 'darcpeugeot/'
env.project_repo = env.project_path + 'repo/'

def safe_deploy():
    # backup
    with cd(env.project_path):
        run('env_darcpeugeot/bin/python repo/darcpeugeot/manage.py dbbackup')
        run('env_darcpeugeot/bin/python repo/darcpeugeot/manage.py mediabackup')

    deploy()

def deploy():
    with cd(env.project_repo):
        run('git pull')
    
    with cd(env.project_repo), prefix('source ../env_darcpeugeot/bin/activate'):
        run('darcpeugeot/manage.py migrate --settings=darcpeugeot.production')

def prepare_deploy():
    local('./manage.py validate')
    local('git add -A && git commit')
    local('git push')
