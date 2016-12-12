#! /bin/bash

# Filename: runserver.sh 2016-12-04
# Author: Huoty <sudohuoty@gmail.com>
# Script starts from here:

set -e

if type activate >/dev/null 2>&1; then
    source activate blog > /dev/null 2>&1
elif type workon >/dev/null 2>&1; then
    source workon blog > /dev/null 2>&1
else
    echo "Error: Unable to switch working environment!"
    exit 1
fi

export PYTHONPATH="/home/huoty/luring/"
export PYTHONUNBUFFERED=1
exec python -m server -p 8800 -r /home/huoty/luring/_site/
