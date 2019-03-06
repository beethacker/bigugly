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

  if line.include? contentOpenTag
    offset = line.index(contentOpenTag) + contentOpenTag.size
    readingBody = true
    contentLines << line[offset..line.size]
  elsif line.include? "</content:encoded>"
    endIndex = line.index("]]") - 1
    contentLines << line[0..endIndex]
    readingBody = false
  elsif readingBody
    contentLines << line
  end
end

puts "---"
puts "title: \"#{title}"
puts "date: #{date}"
puts "tags: #{tags}"
puts "categories: #{categories}"
puts "---"
contentLines.each do |x|
  puts x
end

