# -*- coding:utf-8 -*-
from settings import *

DATABASES = {
     'default': {
         'ENGINE': 'django.db.backends.mysql',
         'NAME': '${database_name}',
         'USER': '${database_user}',
         'PASSWORD': '${database_pass}',
         'HOST': '${database_host}',  # Set to empty string for localhost.
         'PORT': '',  # Set to empty string for default.
     }
 }

INSTALLED_APPS = (
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',
    'django.contrib.sites',

    # apps
    'djblog',
    'djangoskeleton',
    'mediacontent',
    'menuresolver',
    'djangometrics',
    'tagembed',
    'dynaform',

    # libs
    #'haystack',
    'redactor',
)


STATICFILES_DIRS = (
    'assets',
)

STATIC_URL = '/static/'

STATIC_ROOT = os.path.join(BASE_DIR, 'compiled_statics')

MEDIA_URL = '/media/'

MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

SITE_ID = 1

EMAIL_HOST = 'smtp.mandrillapp.com'
EMAIL_HOST_PASSWORD = '55zSnPrpFHyKeC7Z3SDqYQ'
EMAIL_HOST_USER = 'xavier@link-b.com'
EMAIL_PORT = '587'

REDACTOR_OPTIONS = {'lang': 'es', 'plugins': ['extract']}

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [
            os.path.join(BASE_DIR, 'templates'),
            os.path.join(BASE_DIR, 'ui'),
        ],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

HAYSTACK_CONNECTIONS = {
    'default': {
        'ENGINE': 'haystack.backends.elasticsearch_backend.ElasticsearchSearchEngine',
        'URL': 'http://127.0.0.1:9200/',
        'INDEX_NAME': '${index_name}_index',
    },
}

LOGGING = {
    'version': 1,
    'disable_existing_loggers': True,
    'formatters': {
        'verbose': {
            'format': '%(levelname)s %(asctime)s %(module)s %(process)d %(thread)d %(message)s'
        },
        'simple': {
            'format': '%(levelname)s %(message)s'
        },
    },
    'handlers': {
        'null': {
            'level': 'DEBUG',
            'class': 'logging.NullHandler',
        },
        'console': {
            'level': 'DEBUG',
            'class': 'logging.StreamHandler',
            'formatter': 'simple'
        },
        'mail_admins': {
            'level': 'ERROR',
            'class': 'django.utils.log.AdminEmailHandler',
        }
    },
    'loggers': {
        'django': {
            'handlers': ['null'],
            'propagate': True,
            'level': 'INFO',
        },
        'django.request': {
            'handlers': ['mail_admins'],
            'level': 'ERROR',
            'propagate': False,
        },
        '': {
            'handlers': ['console'],
            'level': 'DEBUG',
        }
    }
}
