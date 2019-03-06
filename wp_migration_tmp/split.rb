#!/usr/bin/ruby

def dumpFile(name, lines, title)
  Dir.mkdir "posts" unless File.exists? "posts"
  File.open("posts/#{name}.wp", "w") do |file|
    lines.each do |line|
      file.write line
    end
  end
end

current = []
name = "stub"
title = "stub"

lines = IO.readlines(ARGV[0])
lines.each do |x|
  current << x
  if x.include? "</item>"
    puts name
    puts title
    if not name.empty?
      dumpFile(name, current, title)  
    else
      puts "__SKIPPED___ :("
    end
    current = []
  end

  if x.include? "<wp:post_name>"
    name = x.sub("<wp:post_name>", "").sub("</wp:post_name>", "").strip
    if name.empty?
      puts "This became empty: " + x
    end
  end

  if x.include? "<title>"
    title = x.sub("<title>", "").sub("</title>", "").strip
  end

  if x.include? "<item>"
    current = [x]
  end
end
