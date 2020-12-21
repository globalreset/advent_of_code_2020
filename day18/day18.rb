
result = IO.readlines("day18_input.txt").map { |line|
  stack = []
  ops = line.scan(/[^\s]/)
  while(ops.size()>1)
     ops.each { |op|
       if(op==")" && stack[-2]=="(" && stack[-1]=~/\d/)
         r = stack.pop
         stack.pop
         op = r
       end
       if(op=~/\d/)
         if(stack[-2]=~/\d/ && stack[-1]=="+")
           stack.pop
           stack.push (op.to_i + stack.pop.to_i).to_s
         elsif(stack[-2]=~/\d/ && stack[-1]=="\*")
           stack.pop
           stack.push (op.to_i * stack.pop.to_i).to_s
         else
           stack.push op
         end
       else
         stack.push op
       end
     }
     ops = stack
  end
  ops.pop.to_i
}.sum
puts "Part 1: #{result}"

def calculate(line)
  origLine = line+""
  resolveParens = line.include?("(")
  tmpLine = ""
  anyParens = false
  while(resolveParens)
    lastOpen = []
    newLine = ""
    noCloseFound = true
    line.size.times { |i|
      if(noCloseFound)
        if(line[i]=="(")
          lastOpen.push i
          tmpLine = ""
          anyParens = true
        elsif(line[i]==")" )
          start = lastOpen.pop
          stop = i
          if(start>0)
            newLine = line[0..(start-1)]
          end
          newLine += calculate(line[(start+1)..(stop-1)])
          if(stop+1<line.size())
             newLine += line[(stop+1)...line.size()]
          end
          noCloseFound = false
        end
      end
    }
    line = newLine
    resolveParens = line.include?("(")
  end
  until(line=~/^\d+$/)
     while(line =~ /(\d+) \+ (\d+)/)
       sum = Regexp.last_match(1).to_i + Regexp.last_match(2).to_i
       line.sub!(/#{Regexp.last_match(1)} \+ #{Regexp.last_match(2)}/, sum.to_s)
     end
     while(line =~ /(\d+) \* (\d+)/)
       prod = Regexp.last_match(1).to_i * Regexp.last_match(2).to_i
       line.sub!(/#{Regexp.last_match(1)} \* #{Regexp.last_match(2)}/, prod.to_s)
     end
  end
  return line
end

result = IO.readlines("day18_input.txt").map { |line|
  calculate(line.chomp).to_i
}.sum
puts "Part 2: #{result}"
