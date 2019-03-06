#!/usr/bin/fish

mkdir -p images
for x in (cat imgListing); 
  set filenameTokens (string split / $x); 
  echo $filenameTokens[-1];
  curl $x -o images/$filenameTokens[-1];
end
