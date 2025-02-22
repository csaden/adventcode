# A = rock
# B = paper
# C = scissors

# X = rock
# Y = paper
# Z = scissors

# score the hand thrown
def score_play(played)
  return 1 if played == 'X'
  return 2 if played == 'Y'
  return 3 if played == 'Z'
end

# score win, tie, or loss
def score(round)
  opponent, player = *round.split(" ")

  # tie
  return 3 if opponent == 'A' && player == 'X'
  return 3 if opponent == 'B' && player == 'Y'
  return 3 if opponent == 'C' && player == 'Z'

  # win
  return 6 if opponent == 'A' && player == 'Y'
  return 6 if opponent == 'B' && player == 'Z'
  return 6 if opponent == 'C' && player == 'X'

  # otherwise lose
  return 0
end

file = File.open("./day02_input.txt")
data = file.readlines.map(&:chomp)
file.close

def calculate_score(rounds)
  rounds.map {|round| score(round) + score_play(round.slice(-1))} .inject(0, :+)
end

puts calculate_score(data)

# Switch the strategy now
# X = player losses / 0 points
# Y = player ties   / 3 points
# Z = player wins   / 6 points

# score the hand thrown
def score_played_part2(round)
  outcome = round.slice(-1)

  if round[0] == 'A' # opponent throws rock
    return 3 if outcome == 'X' # lose with scissors
    return 1 if outcome == 'Y' # tie with rock
    return 2 if outcome == 'Z' # win with paper
  end

  if round[0] == 'B' # opponent throws paper
    return 1 if outcome == 'X' # lose with rock
    return 2 if outcome == 'Y' # tie with paper
    return 3 if outcome == 'Z' # win with scissors
  end

  if round[0] == 'C' # opponent throws scissors
    return 2 if outcome == 'X' # lose with paper
    return 3 if outcome == 'Y' # tie with scissors
    return 1 if outcome == 'Z' # win with rock
  end
end

# scores win, tie, loss
def score_part2(outcome)
  return 0 if outcome == 'X'
  return 3 if outcome == 'Y'
  return 6 if outcome == 'Z'
end

def calculate_score_part2(rounds)
  rounds.map {|round| score_part2(round.slice(-1)) + score_played_part2(round)} .inject(0, :+)
end

puts calculate_score_part2(data)
