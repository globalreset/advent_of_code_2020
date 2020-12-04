validFields = {
  "byr" => "^(19[2-9][0-9]|200[0-2])$", #(Birth Year)
  "iyr" => "^(201[0-9]|2020)$", #(Issue Year)
  "eyr" => "^(202[0-9]|2030)$", #(Expiration Year)
  "hgt" => "^(1[5-8][0-9]cm|19[0-3]cm|59in|6[0-9]in|7[0-6]in)$", #(Height)
  "hcl" => "^#[0-9a-f]{6}$", #(Hair Color)
  "ecl" => "^(amb|blu|brn|gry|grn|hzl|oth)$", #(Eye Color)
  "pid" => "^[0-9]{9}$", #(Passport ID)
  "cid" => "^[^s]+$" #(Country ID)
}
passportList = []
passport = {}
IO.readlines("dayfour_input.txt").each { |line|
   if(line.chomp == "")
      if(passport.keys.size()>0)
         passportList.push passport
         passport = {}
      end
    else
      line.scan(/\w+:[^\s]+/)
          .collect { |pair| pair.split(":") }
          .each { |key, val| passport[key] = val }
   end
}
# those goddamn fenceposts
if(passport.keys.size()>0)
   passportList.push passport
end

validCnt = 0
passportList.each { |passport|
  valid = 0
  validFields.keys.each { |expKey|
    valid = (valid<<1) + ((passport.key?(expKey))?1:0)
  }
  validCnt += 1 if([0xff,0xfe].include?(valid))
}

puts "Part 1: valid passports = #{validCnt}"

validCnt = 0
passportList.each { |passport|
  valid = 0
  validFields.keys.each { |expKey|
    valid = (valid<<1) + ((passport.key?(expKey) && (passport[expKey] =~ /#{validFields[expKey]}/))?1:0)
  }
  validCnt += 1 if([0xff,0xfe].include?(valid))
}

puts "Part 2: valid passports = #{validCnt}"
