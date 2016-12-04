#! /bin/bash

# Filename: runserver.sh 2016-12-04
# Author: Huoty <sudohuoty@gmail.com>
# Script starts from here:

workon blog > /dev/null 2>&1
export PYTHONPATH="/home/huoty/luring/"
export PYTHONUNBUFFERED=1
python -m server -p 8800 -r _site/
