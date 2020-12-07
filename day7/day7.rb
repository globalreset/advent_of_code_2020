bagTbl = {}
BagGraph = Struct.new(:color, :children, :parents)

IO.readlines("day7_input.txt").each { |line|
  if(line =~ /([\w ]+) bags contain (no other bags|.*)\./)
    parentColor = Regexp.last_match(1)
    parentBag = (bagTbl[parentColor] ||= BagGraph.new(parentColor, {}, []))
    if(Regexp.last_match(2)!="no other bags")
      Regexp.last_match(2).split(",").each { |subbag|
        if(subbag =~ /(\d+) ([\w ]+) bag/)
          qty = Regexp.last_match(1).to_i
          color = Regexp.last_match(2)
          childBag = (bagTbl[color] ||= BagGraph.new(color, {}, []))
          childBag.parents <<= parentColor
          parentBag.children[color] = qty
        else
          raise "regex error B"
        end
      }
    end
  else
    raise "regex error A"
  end
}

def findBagParents(bagTbl, bag)
  return [bag.parents + bag.parents.reduce([]){|acc, nextColor| acc <<= findBagParents(bagTbl, bagTbl[nextColor])}].flatten.sort.uniq
end

puts "Part 1 answer: #{findBagParents(bagTbl, bagTbl["shiny gold"]).size()}"

def countBagsChildren(bagTbl, bag)
  return bag.children.keys.reduce(0) { |acc, nextColor|
    acc += bag.children[nextColor] * (1 + countBagsChildren(bagTbl, bagTbl[nextColor]))
  }
end

puts "Part 2 answer: #{countBagsChildren(bagTbl, bagTbl["shiny gold"])}"


# - - - - - - - - - - - - - - - - - - - - - -
# - - - - - - - - - - - - - - - - - - - - - -
# first crack, for posterity's sake.
# Also, not sure which solution I like more
bagParents = {}
bagChildren = {}
IO.readlines("day7_input.txt").each { |line|
  if(line =~ /([\w ]+) bags contain (no other bags|.*)\./)
    targetColor = Regexp.last_match(1)
    if(Regexp.last_match(2)!="no other bags")
      Regexp.last_match(2).split(",").each { |subbag|
        if(subbag =~ /(\d+) ([\w ]+) bag/)
          qty = Regexp.last_match(1).to_i
          color = Regexp.last_match(2)
          bagParents[color] ||= {}
          bagParents[color][targetColor] = qty
          bagChildren[targetColor] ||= {}
          bagChildren[targetColor][color] = qty
        else
          raise "regex error B"
        end
      }
    end
  else
    raise "regex error A"
  end
}

def countBags(bags, color)
  if(bags[color]==nil || bags[color].keys.size() == 0)
    return []
  else
    [bags[color].keys + bags[color].keys.reduce([]) { |acc,nextcolor| acc <<= countBags(bags, nextcolor) }].flatten.sort.uniq
  end
end

puts "Part 1 answer: #{countBags(bagParents, "shiny gold").size()}"

def countBagsQty(bags, color)
  if(bags[color]==nil || bags[color].keys.size() == 0)
    return 0
  else
    return bags[color].keys.reduce(0) { |acc,nextcolor|
      acc += bags[color][nextcolor] + bags[color][nextcolor] * countBagsQty(bags, nextcolor)
    }
  end
end

puts "Part 2 answer: #{countBagsQty(bagChildren, "shiny gold")}"
