#!/usr/bin/fish
hugo -d deploy
pushd .
cd deploy
git add .
git commit -m "Updating Big Ugly Blog"
git push
popd
