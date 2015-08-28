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
