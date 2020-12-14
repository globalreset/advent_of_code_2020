
lines = IO.readlines("day13_input.txt")

timestamp = lines[0].to_i
busIDs = lines[1].split(",").map {|l| l.to_i }

timestamp = 939
#busIDs = [7,13,0,0,59,0,31,19]
#busIDs = [67,7,59,61]
#busIDs = [67,0,7,59,61]
#busIDs = [67,7,0,59,61]
#busIDs = [1789,37,47,1889]
#puts timestamp
#puts busIDs.inspect

busWithIndex = busIDs.map.with_index{ |id, i| [i,id] }
                     .select{ |a| a[1]!=0 }
puts busIDs.inspect
puts busWithIndex.inspect

puts busIDs.map { |id|
  if(id > 0)
    [id, id*((timestamp / id) + 1) - timestamp]
  end
}.compact.sort {|a,b| a[1]<=>b[1]}.inspect

increment = 1
numCheck = 0
currTs = 1
puts "bus=#{busWithIndex[numCheck].inspect}, currTs=#{currTs}, increment=#{increment}"
while(true)
  if(((currTs + busWithIndex[numCheck][0]) % busWithIndex[numCheck][1])==0)
    increment *= busWithIndex[numCheck][1]
    numCheck += 1
    if(numCheck==busWithIndex.size())
      puts currTs
      break
    else
      puts "bus=#{busWithIndex[numCheck].inspect}, currTs=#{currTs}, increment=#{increment}"
    end
  else
    currTs += increment
  end
end

increment = 1
numCheck = 0
currTs = 1
while(true)
  busTable = busWithIndex.map{ |b|
      (currTs+b[0]) % b[1]
  }
  if(busTable[numCheck]==0)
    if(numCheck==busTable.size()-1)
      puts "increment=#{increment}, currTs=#{currTs}, numCheck=#{numCheck}"
      puts "done"
      exit
    else
      puts "increment=#{increment}, currTs=#{currTs}, numCheck=#{numCheck}"
      increment = busWithIndex[0..numCheck].reduce(1) {|acc,el| acc*=el[1]}
      puts "new increment = #{increment}"
      numCheck += 1
    end
  end
  currTs += increment
end

prevSucc = 0
numCheck = 2
increment = 1
i = 1
while(true)
  curr = busIDs[0]*i
  busTS = busWithIndex.map{ |b|
    nextTs = (((curr-1)/b[1]) + 1)*b[1] - b[0]
  }
  numMismatch = 0
  numMatch = 0
  busTS.size().times { |j|
    numMismatch += 1 if(busTS[j]!=curr)
    if(numMismatch==0)
      numMatch += 1 if(busTS[j]==curr)
    end
  }

  if(numMatch==busTS.size())
    puts "i=#{i}, curr=#{curr}"
    exit
  elsif(numMatch==numCheck)
    puts "i=#{i}, curr=#{curr}, incr=#{increment}, numMatch=#{numMatch}, #{busTS[0..(numCheck-1)].inspect}, busTS=#{busTS.inspect}"
    if(prevSucc==0)
      prevSucc = i
    else
      increment = i - prevSucc
      i = prevSucc
      prevSucc = 0
      numCheck += 1
    end
    if(numCheck==busIDs.size())
      exit
    end
  end

  i += increment
end
2000000000.times { |i|
  curr = busWithIndex[-1][1] * i + busWithIndex[-1][0]
  puts "i=#{i}, curr=#{curr}, busTS=#{busTS.inspect}, #{busTS.reduce(true) {|acc,el| acc = acc && (el==curr)}}"
  if(busTS.reduce(true) {|acc,el| acc = acc && (el==curr)})
    puts curr
    exit
  end
}
