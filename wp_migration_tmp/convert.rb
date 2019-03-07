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
listCount = 0

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

  if line.include? "http://cookwithchef.com/wp-content/uploads"
      regex = /\"http:\/\/cookwithchef.com\/wp-content\/uploads\/[0-9]*\/[0-9]*\/([^> ]*)\"/
      matching = regex.match(line)
      until matching.nil?
        line.gsub!(matching[0], "\"{{< resource url=\"img/" + matching[1] + "\">}}\"")
        matching = regex.match(line)
      end
  end

  if line.include? contentOpenTag
    offset = line.index(contentOpenTag) + contentOpenTag.size
    readingBody = true
    line = line[offset..line.size]
  end

  #NOTE this might actually be the same line, if all the content fit on a single line....
  if line.include? "</content:encoded>"
    endIndex = line.index("]]") - 1
    line = line[0..endIndex]
    stopReadingBody = true #NOTE, we stop reading body at end of this loop, we still need to read THIS LINE THOUGH
  end

  if readingBody
    if line.include? "<ul>" or line.include? "<ol>"
      listCount += 1
    end
    if line.include? "</ul>" or line.include? "</ol>"
      listCount -= 1
    end
    if listCount == 0
      line = "<p>#{line}</p>"
    end
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

