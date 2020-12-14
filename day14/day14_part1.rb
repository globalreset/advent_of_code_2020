require "../util.rb"

input = IO.readlines("day14_input.txt").map { |line|
  puts line
  if(line=~ /mask = ([01X]+)/ )
    mask = 0
    value = 0
    Regexp.last_match(1).scan(/\w/).each { |c|
      mask <<= 1
      mask |= 1 if(c=='X')
      value <<= 1
      value |= c.to_i if(c!='X')
    }

    {
      :op => :mask,
      :mask => mask,
      :value => value
    }
  elsif(line=~ /mem\[(\d+)\] = (\d+)/)
    {
      :op => :mem,
      :addr => Regexp.last_match(1).to_i,
      :data => Regexp.last_match(2).to_i
    }
  end
}

memory = {}
mask = -1
value = 0
puts input[0].op
input.each { |inst|
  case(inst.op)
  when :mask
    mask = inst.mask
    value = inst.value
  when :mem
    memory[inst.addr] = (inst.data & mask) | value
  end
}

puts "Part 1 answer: #{memory.values.reduce(:+)}"
