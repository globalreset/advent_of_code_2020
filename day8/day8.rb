program = IO.readlines("day8_input.txt")
            .map{ |input| input.split(" ") }
            .map{ |op,arg| {:op => op.to_sym, :arg => arg.to_i} }

def executeProgram(program)
  acc = 0
  ptr = 0
  ptrs = {}
  while(ptr < program.size)
    ptrs[ptr] = :dirty
    case(program[ptr][:op])
    when :nop
      ptr += 1
    when :jmp
      ptr += program[ptr][:arg]
    when :acc
      acc += program[ptr][:arg]
      ptr += 1
    end
    return false, acc if(ptrs[ptr]==:dirty)
  end
  return true, acc
end

status, acc = executeProgram(program)
puts "Part 1 answer: #{status}, acc=#{acc}"

swapOp = [:jmp, :nop]
program.select { |p| swapOp.include?(p[:op]) }.each { |p|
  i = swapOp.find_index(p[:op])
  p[:op] = swapOp[i ^ 1]
  status, acc = executeProgram(program)
  p[:op] = swapOp[i]
  if(status)
     puts "Part 2 answer: #{status}, acc=#{acc}"
     break
  end
}
