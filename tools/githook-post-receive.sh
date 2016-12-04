#! /bin/bash

# Filename: githook-post-receive.sh 2016-12-04
# Author: Huoty <sudohuoty@gmail.com>
# Script starts from here:

# Update code
cd ..
env -i git checkout HEAD .

# clint config:
#   git remote add vultr ssh://huoty@vultrhost:/home/huoty/luring

# Build site
jekyll build
