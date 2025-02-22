def find_marker(str, n)
  hash_map = {}
  marker = 0

  str.split('').each_with_index do |char, index|
    # increment char count
    if hash_map.key?(char)
      hash_map[char] += 1
    else
      hash_map[char] = 1
    end

    if index > n-1
      # decrement char count
      prev_char = str[index-n]
      hash_map[prev_char] -= 1
      if hash_map[prev_char] == 0
        hash_map.delete(prev_char)
      end
    end

    if hash_map.length() == n
      marker = index+1 # marker is 1-based indexed
      break
    end
  end
  marker
end



file = File.open("./day06_input.txt")
data = file.readlines.map(&:chomp).take(1)[0]
file.close

p find_marker(data, 4)
p find_marker(data, 14)