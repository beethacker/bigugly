#!/usr/bin/fish
hugo -d docs
git add .
git commit 
git push
