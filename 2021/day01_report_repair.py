# --- Day 1: Report Repair ---
# After saving Christmas five years in a row, you've decided to take a vacation at a nice resort on a tropical island.
# Surely, Christmas will go on without you.

# The tropical island has its own currency and is entirely cash-only.
# The gold coins used there have a little picture of a starfish; the locals just call them stars.
# None of the currency exchanges seem to have heard of them, but somehow,
# you'll need to find fifty of these coins by the time you arrive so you can pay the deposit on your room.

# To save your vacation, you need to get all fifty stars by December 25th.

# Collect stars by solving puzzles. Two puzzles will be made available on each day in the Advent calendar;
# the second puzzle is unlocked when you complete the first. Each puzzle grants one star. Good luck!

# Before you leave, the Elves in accounting just need you to fix your expense report (your puzzle input);
# apparently, something isn't quite adding up.

# Specifically, they need you to find the two entries that sum to 2020 and then multiply those two numbers together.

# For example, suppose your expense report contained the following:

# 1721
# 979
# 366
# 299
# 675
# 1456
# In this list, the two entries that sum to 2020 are 1721 and 299. Multiplying them together produces 1721 * 299 = 514579,
# so the correct answer is 514579.

# Of course, your expense report is much larger. Find the two entries that sum to 2020; what do you get if you multiply them together?

# To play, please identify yourself via one of these services:

# --- Part Two ---
# The Elves in accounting are thankful for your help;
# one of them even offers you a starfish coin they had left over from a past vacation.
# They offer you a second one if you can find three numbers in your expense report that meet the same criteria.

# Using the above example again, the three entries that sum to 2020 are 979, 366, and 675.
# Multiplying them together produces the answer, 241861950.

# In your expense report, what is the product of the three entries that sum to 2020?

from utils import read_file

def find_two_sum(arr, target = 2020):
    # use map to store number and it's difference from the target
    diff_to_target = {}
    for num in arr:
        diff = target - num
        if diff_to_target.get(diff):
            print('Found pair', num, diff)
            return num * diff
        diff_to_target[num] = diff
    return None

def find_three_sum(arr, target=2020):
    diff_to_target = {}
    l = len(arr)
    for i in range(0, l-1):
        sum_pairs = set()
        curr_sum = target - arr[i]
        for j in range(i+1, l):
            if curr_sum - arr[j] in sum_pairs:
                print('Found triplet', arr[i], arr[j], curr_sum - arr[j])
                return arr[i] * arr[j] * (curr_sum - arr[j])
            sum_pairs.add(arr[j])
    return None


if __name__ == "__main__":
    # part 1
    lines = read_file('day01_input.txt')
    arr = [int(line) for line in lines]
    arr.sort()
    print(find_two_sum(arr))

    # part 2
    print(find_three_sum(arr))
