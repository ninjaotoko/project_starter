# -*- coding:utf-8 -*-

from django.views.generic import TemplateView
from django.shortcuts import render
from django.utils.translation import ugettext_lazy as _
from django.conf import settings
import logging
logger = logging.getLogger(__name__)


class UIFlatView(TemplateView):
    def get_template_names(self):
        return [
                self.kwargs.get('tempate_name')
                ]
