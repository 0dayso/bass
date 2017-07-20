#!/usr/bin/env python
# -*- coding: utf-8 -*-
from fabric.api import local,cd,run, env, put
import os
import getpass
user = getpass.getuser()

def update (commit=''):
    """fab update:提交注释"""
    local('git pull')
    local('git add .')

    if commit:
        local('git commit -a -m "%s"' % commit)
    else:
        local('git commit -a -m "%s"' % user)

    local('git push -v --progress  "origin" master:master')

def push ():
    local('git push -v --progress  "origin" master:master')

def commit (commit=''):
    if commit:
        local('git commit -a -m "%s"' % commit)
    else:
        local('git commit -a -m "%s"' % user)
    local('git push -v --progress  "origin" master:master')