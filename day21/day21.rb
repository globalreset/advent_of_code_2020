input = IO.readlines("day21_input.txt")

Food = Struct.new(:ingredients, :allergens)
foods = []
allergenMap = {}
ingredients = []
input.each { |line|
  if(line =~ /(.*) \(contains (.*)\)/)
    food = Food.new(
      Regexp.last_match(1).split(" "),
      Regexp.last_match(2).split(", "))
    foods <<= food
    ingredients <<= food.ingredients
    food.allergens.each { |allergen|
      if(allergenMap[allergen])
        allergenMap[allergen] &= food.ingredients
      else
        allergenMap[allergen] = food.ingredients
      end
    }
  end
}
ingredients = ingredients.flatten.sort.uniq
possibleIngredients = allergenMap.values.flatten
nonAllergyIngredients = ingredients.collect { |ing|
  ing unless(possibleIngredients.include?(ing))
}.compact

puts "Part 1 answer: #{nonAllergyIngredients.reduce(0) { |cnt,ing|
   cnt += foods.reduce(0) { |subcnt, food|
     if(food.ingredients.include?(ing))
       subcnt + 1
     else
       subcnt
     end
   }
}}"

solvedIngredients = {}
while(allergenMap.size > 0)
  allergenMap.keys.each { |allergen|
    if(allergenMap[allergen].size()==1)
      solvedIngredients[allergenMap[allergen][0]] = allergen
      allergenMap.delete(allergen)
    else
      allergenMap[allergen] = allergenMap[allergen].collect { |ing|
        ing unless(solvedIngredients.keys.include?(ing))
      }.compact
    end
  }
end
puts "Part 2 answer: #{solvedIngredients.keys.sort { |a,b|
  solvedIngredients[a]<=>solvedIngredients[b]
}.join(",")}"
