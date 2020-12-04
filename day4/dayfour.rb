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
  valid = ""
  validFields.keys.each { |expKey|
    if(passport.key?(expKey))
      valid = "#{valid}1"
    else
      valid = "#{valid}0"
    end
  }
  validCnt += 1 if(valid=="11111110" || valid=="11111111")
}

puts "Part 1: valid passports = #{validCnt}"

validCnt = 0
passportList.each { |passport|
  puts "--"
  valid = ""
  validFields.keys.each { |expKey|
    if(passport.key?(expKey))
      if(passport[expKey] =~ /#{validFields[expKey]}/)
        valid = "#{valid}1"
      else
        puts "INVALID: passport['#{expKey}'] => '#{passport[expKey]}'"
        valid = "#{valid}0"
      end
    else
      valid = "#{valid}0"
    end
  }
  validCnt += 1 if(valid=="11111110" || valid=="11111111")
}

puts "Part 2: valid passports = #{validCnt}"
