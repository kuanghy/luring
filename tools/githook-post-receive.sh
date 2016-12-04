#! /bin/bash

# Filename: githook-post-receive.sh 2016-12-04
# Author: Huoty <sudohuoty@gmail.com>
# Script starts from here:

# Update code
git --work-tree=/home/huoty/luring --git-dir=/home/huoty/luring/.git checkout -f HEAD

# Build site
jekyll build

# clint config:
#   git remote add vultr ssh://huoty@vultrhost:/home/huoty/luring
#
# server .git/config add:
#   [receive]
#       denyCurrentBranch = ignore
#
# install hook:
#   cd .git/hooks/
#   ln -s ../../tools/githook-post-receive.sh post-receive
