#!/usr/bin/ruby


def extract(line, open, close)
 startIndex = line.index(open) + open.size
 closeIndex = line.index(close, startIndex) - 1
 if startIndex.nil? 
   startIndex = 0
 end
 if closeIndex.nil?
   closeIndex = line.size - 1
 end
 #puts "Line = #{line} from #{startIndex} to #{closeIndex}"
 return line[startIndex..closeIndex]
end

def extractTag(line)
  return extract(line, ">", "<")
end

title = "NO TITLE?"
tags = []
categories = []
date = nil
contentLines = []
readingBody = false
stopReadingBody = false
contentOpenTag =  "<content:encoded><![CDATA["

IO.readlines(ARGV[0]).each do |line|

  if line.include? "<title>" 
    title = extractTag(line)
  end

  if line.include? "<wp:post_date>"
    date = extractTag(line)
  end

  if line.include? "<category domain=\"post_tag\""
    tags << extract(line, "![CDATA[", "]]")
  end

  if line.include? "<category domain=\"category\""
    categories << extract(line, "![CDATA[", "]]")
  end

  if line.include? "wp-content/uploads"
    line.gsub!(/http:\/\/cookwithchef.com\/wp-content\/uploads\/[0-9]*\/[0-9]*/, "/img")
  end
 
  if line.include? contentOpenTag
    offset = line.index(contentOpenTag) + contentOpenTag.size
    readingBody = true
    line = line[offset..line.size]
  elsif line.include? "</content:encoded>"
    endIndex = line.index("]]") - 1
    line = line[0..endIndex]
    stopReadingBody = true #NOTE, we stop reading body at end of this loop, we still need to read THIS LINE THOUGH
  end

  if readingBody
    contentLines << line
  end

  if stopReadingBody
    stopReadingBody = false
    readingBody = false
  end
end

puts "---"
puts "title: \"#{title}\""
puts "date: #{date}"
puts "tags: #{tags}"
puts "categories: #{categories}"
puts "---"
contentLines.each do |x|
  puts x
end

