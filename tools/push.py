#! /usr/bin/env python
# -*- coding: utf-8 -*-

# *************************************************************
#  Copyright (c) Huoty - All rights reserved
#
#      Author: Huoty <sudohuoty@gmail.com>
#  CreateTime: 2016-12-04 22:22:13
# *************************************************************

from __future__ import print_function

import subprocess
from argparse import ArgumentParser

def main():
    parser = ArgumentParser(description="Push this repo")
    parser.add_argument("-r", "--repo", default="origin", help="The repo need to push")
    parser.add_argument("-a", "--all", action="store_true", help="Push all repo")

    options = parser.parse_args()

    if options.all:
        output = subprocess.check_output("git remote -v", shell=True)
        repos = {}
        for repo in output.strip().split('\n'):
            pass
    elif options.repo:
        cmd = "git push {repo} master".format(repo=options.repo)
        subprocess.check_output(cmd, shell=True)
    else:
        parser.print_help()

# Script starts from here

if __name__ == "__main__":
    main()
