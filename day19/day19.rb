input = IO.readlines("day19_input.txt")

rules = {}
messages = []
input.each { |line|
  if(line =~ /^(\d+): (.*)/)
    ruleIndex = Regexp.last_match(1)
    ruleValue = Regexp.last_match(2).split(" ")
    if(ruleValue[0] =~ /\"(.*)\"/)
      ruleValue = Regexp.last_match(1)
    end
    rules[ruleIndex] = ruleValue
  elsif(line.size()>0)
    messages <<= line
  end
}

def getPattern(rules, startIndex, part)
  rulePattern = rules[startIndex]
  while(rulePattern.any? { |p| p =~ /^\d+$/ })
    rulePattern = rulePattern.map { |r|
      if(r =~ /^\d+$/)
        exp = rules[r]
        if(exp.is_a?(Array))
          if(part==2 && r=="8")
            ["42","+"]
          elsif(part==2 && r=="11")
            ["(", "42","(?1)?", "31", ")"]
          else
            ["(?:",exp,")"]
          end
        else
          exp
        end
      else
        r
      end
    }.flatten
  end
  return rulePattern.join
end

rulePattern = getPattern(rules, "0", 1)
puts "Part 1: matches=#{messages.map { |m| (m=~/^#{rulePattern}$/)?1:0 }.reduce(:+)}"

rulePattern = getPattern(rules, "0", 2)
#puts "Part 2: matches=#{messages.map { |m| (m=~/^#{rulePattern}$/)?1:0 }.reduce(:+)}"

#Ruby failed to parse my regex, but regex101 liked it
# https://regex101.com/r/ldqyR0/2
puts "0: ^(#{rulePattern})$"
#puts "8: #{getPattern(rules, "8", 2)}"
#puts "11: #{getPattern(rules, "11", 2)}"
