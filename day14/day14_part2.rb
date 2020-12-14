require "../util.rb"

memory = {}
maskFloat = 0
maskSet = 0
value = 0
floats = []
IO.readlines("day14_input.txt").map { |line|
  puts line
  if(line=~ /mask = ([01X]+)/ )
    puts Regexp.last_match(1)
    floats = []
    maskFloat = 0
    maskSet = 0
    chars = Regexp.last_match(1).scan(/\w/)
    chars.each_index { |i|
      maskFloat <<= 1
      maskSet <<= 1
      maskSet |= 1 if(chars[i]=='1')
      if(chars[i]=='X')
        maskFloat |= 1
        floats.unshift 35-i
      end
    }
  elsif(line=~ /mem\[(\d+)\] = (\d+)/)
    addr = Regexp.last_match(1).to_i
    data = Regexp.last_match(2).to_i
    (1<<floats.size()).times { |offset|
      bits = offset
      addr = (Regexp.last_match(1).to_i & ~maskFloat) | maskSet
      floats.each { |float|
        addr |= ((bits & 1) << float)
        bits >>= 1
      }
      memory[addr] = data
    }
  end
}
puts "Part 2 answer: #{memory.values.reduce(:+)}"
