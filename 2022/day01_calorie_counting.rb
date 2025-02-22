file = File.open("./day01_input.txt")
data = file.readlines.map(&:to_i)
file.close

def get_max_calories(arr)
  max_calories = 0
  calories = 0

  i = 0
  while i < arr.length - 1
    if arr[i] == 0
      calories = 0
    else
      calories += arr[i]
      if calories > max_calories
        max_calories = calories
      end
    end
    i += 1
  end
  max_calories
end

puts get_max_calories(data)

def get_top3(arr)
  calories = 0
  holdings = []

  i = 0
  while i < arr.length - 1
    if arr[i] == 0
      holdings << calories
      calories = 0
    else
      calories += arr[i]
    end
    i += 1
  end
  holdings << calories
  holdings.sort.last(3).inject(0, &:+)
end

puts get_top3(data)
