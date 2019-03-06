#!/usr/bin/fish

for x in (ls posts/*.wp); ./convert.rb $x > ../content/posts/(basename $x .wp).html; end

