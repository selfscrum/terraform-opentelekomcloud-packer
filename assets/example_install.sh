#!/bin/bash

sudo -s  <<HEREDOC
## update host
apt-get -y update

echo "hello install" > i_was_here.md

HEREDOC