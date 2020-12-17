tickets = []
rules = {}

lines = [
  "class: 1-3 or 5-7",
  "row: 6-11 or 33-44",
  "seat: 13-40 or 45-50",
  "",
  "your ticket:",
  "7,1,14",
  "",
  "nearby tickets:",
  "7,3,47",
  "40,4,50",
  "55,2,20",
  "38,6,12"
].each { |line|}
lines = [
  "class: 0-1 or 4-19",
  "row: 0-5 or 8-19",
  "seat: 0-13 or 16-19",
  "",
  "your ticket:",
  "11,12,13",
  "",
  "nearby tickets:",
  "3,9,18",
  "15,1,5",
  "5,14,9"
].each { |line| }
IO.readlines("day16_input.txt").each { |line|
  if(line =~ /([\w ]+): (\d+)-(\d+) or (\d+)-(\d+)/)
    rules[Regexp.last_match(1)] = [
      (Regexp.last_match(2).to_i..Regexp.last_match(3).to_i).to_a,
      (Regexp.last_match(4).to_i..Regexp.last_match(5).to_i).to_a
    ].flatten
  elsif(line =~ /^\d+,/)
    tickets.push line.split(",").map{|f| f.to_i }
  end
}

invalidFields = []
validTickets = []
tickets.each { |ticket|
  validTicket = true
  ticket.each { |field|
    unless(rules.values.reduce(false) { |valid,rule|
         valid ||= rule.include?(field)
       })
       invalidFields.push(field)
       validTicket = false
    end
  }
  validTickets.push(ticket) if(validTicket)
}

puts "Part 1 answer: #{invalidFields.reduce(:+)}"
puts

colBitMask = {}
max = rules.keys.map(&:size).max
rules.keys.each { |ruleName|
  colBitMask[ruleName] = ((1<<rules.keys.size)-1)
  validTickets.each { |ticket|
    ticketMask = 0
    ticket.each { |field|
      ticketMask <<= 1
      ticketMask |= 1 if(rules[ruleName].include?(field))
    }
    colBitMask[ruleName] &= ticketMask
  }
}

colBitMask.each { |name, mask|
  puts "colBitMask[#{"%-#{max}s"%name}] = #{"%#{rules.keys.size}s"%mask.to_s(2)} "
}
puts

solvedBitMask = 0
colBitMask = colBitMask.sort_by { |k,v| v.to_s(2).scan(/1/).size }
colAssign = {}
colBitMask.each { |name, mask|
  mask &= ~solvedBitMask
  s = mask.to_s(2)
  if(s.scan(/1/).size>1)
    raise "bitmask for #{name} did not resolve. mask=#{mask}, solvedBitMask=#{solvedBitMask}"
  else
    solvedBitMask |= mask
    colAssign[name] = 20 - s.size
  end
  puts "colBitMask[#{"%-#{max}s"%name}] = #{"%#{rules.keys.size}s"%mask.to_s(2)} => column #{colAssign[name]}"
}
puts

result = 1
colAssign.each { |k,v|
  if(k=~/^departure/)
    result *= tickets[0][v]
  end
}
puts "Part 2 answer: #{result}"
