#!/bin/sh

# Create a test repo which we can use for the online::push tests
mkdir $HOME/_temp
git init --bare $HOME/_temp/test.git
git daemon --listen=localhost --export-all --enable=receive-pack --base-path=$HOME/_temp $HOME/_temp 2>/dev/null &

sudo start ssh

ssh-keygen -t rsa -f ~/.ssh/id_rsa -N "" -q
cat ~/.ssh/id_rsa.pub >>~/.ssh/authorized_keys
ssh-keyscan -t rsa localhost >>~/.ssh/known_hosts

export GITTEST_REMOTE_GIT_URL="git://localhost/test.git"
export GITTEST_REMOTE_SSH_URL="ssh://localhost/$HOME/_temp/test.git"
export GITTEST_REMOTE_SSH_USER=$USER
export GITTEST_REMOTE_SSH_KEY="$HOME/.ssh/id_rsa"
export GITTEST_REMOTE_SSH_PUBKEY="$HOME/.ssh/id_rsa.pub"
export GITTEST_REMOTE_SSH_PASSPHRASE=""

julia remote_clone.jl
