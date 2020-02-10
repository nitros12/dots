#!/usr/bin/env python

from subprocess import check_output
from re import sub

def get_pass(account):
    u = check_output("/usr/bin/pass email/{account}/user".format(account=account), shell=True)
    p = check_output("/usr/bin/pass email/{account}/pass".format(account=account), shell=True)
    return {"password": p, "user": u}

def folder_filter(name):
    return (name not in ['INBOX',
                         '[Gmail]/Spam',
                         '[Gmail]/Important',
                         '[Gmail]/Starred'])

def nametrans(name):
    return sub(r'^(Starred|Sent Mail|Drafts|Trash|All Mail|Spam)$', '[Gmail]/\\1', name)

def nametrans_reverse(name):
    return sub(r'^(\[Gmail\]/)', '', name)
