joltages = IO.readlines("day10_input.txt").map{|line| line.to_i}.sort
joltages.push(joltages[-1] + 3) # device built-in adapter

diffs = {}
joltages.reduce(0) { |r,a|
  diffs[a-r] = (diffs[a-r] || 0) + 1
  r = a
}
puts "Part 1 answer: #{diffs[1] * diffs[3]}"

def searchJolts(devJolt, highJolt, joltList, cache)
  return (devJolt==highJolt) ? 1 :
    joltList.select{ |jolt| ((highJolt+1)..(highJolt+3)).include?(jolt) }
           .reduce(0){ |cnt, jolt|
      cnt += cache[jolt] || (cache[jolt] = searchJolts(devJolt, jolt, joltList, cache))
    }
end

puts "Part 2 answer: #{searchJolts(joltages[-1], 0, joltages, {})}"
