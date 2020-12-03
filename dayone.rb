TARGET = 2020
inputList = IO.readlines("dayone_input.txt").collect{ |line| line.to_i }
expenseList = []
pairList = []
inputList.size.times {
  expense = inputList.pop
  expenseList.push(expense)
  inputList.each { |input|
    pairList.push [expense, input]
    if((expense + input) == TARGET)
      puts "Part 1: #{expense} * #{input} = #{expense*input}"
    end
  }
}
expenseList.each { |exp3|
  newPairList = []
  pairList.each { |exp1,exp2|
    if(exp3!=exp1 && exp3!=exp2)
      newPairList.push [exp1,exp2]
      if((exp1 + exp2 + exp3) == TARGET)
        puts "Part 2: #{exp1} * #{exp2} * #{exp3} = #{exp1 * exp2 * exp3}"
      end
    end
  }
  pairList = newPairList
}
