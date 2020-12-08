program = IO.readlines("day8_input.txt").map{ |line| line.split(" ") }

def executeProgram(program)
  acc = 0
  line = 0
  linesVisited=[]
  while(line < program.size)
    linesVisited.push(line)
    case(program[line][0])
    when "nop"
      nextLine = line + 1
    when "jmp"
      nextLine = line + program[line][1].to_i
    when "acc"
      acc += program[line][1].to_i
      nextLine = line + 1
    end
    if(linesVisited.include?(nextLine))
      raise "loop detected: acc=#{acc}, lastLine=#{line}, nextLine=#{nextLine}"
    else
      line = nextLine
    end
  end
  return acc
end

begin
   executeProgram(program)
rescue => error
  puts "Part 1 answer: #{error.message}"
end


swapOp = ["jmp", "nop"]
program.select { |op| swapOp.include?(op[0]) }.each { |op|
  i = swapOp.find_index(op[0])
  op[0] = swapOp[i ^ 1]
  begin
    puts "Part 2 answer: acc=#{executeProgram(program)}"
  rescue => error
  end
  op[0] = swapOp[i]
}
