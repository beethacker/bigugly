#!/usr/bin/fish

for x in (ls posts/); ./convert.rb posts/$x > posts/(basename $x .wp).html; end
