#!/usr/bin/fish
grep http://cookwithchef.com/wp-content/uploads thebiguglyhouseblog.wordpress.2019-03-05.xml | sed -r "s/.*(http[^ ]*)/\1/" | sed "s/<\/.*//" | sed "s/\".*//"  
