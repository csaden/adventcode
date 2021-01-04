# --- Day 4: Passport Processing ---
# You arrive at the airport only to realize that you grabbed your North Pole
# Credentials instead of your passport. While these documents are extremely similar,
# North Pole Credentials aren't issued by a country and therefore aren't actually valid
# documentation for travel in most of the world.

# It seems like you're not the only one having problems, though; a very long line has
# formed for the automatic passport scanners, and the delay could upset your travel itinerary.

# Due to some questionable network security, you realize you might be able to solve
# both of these problems at the same time.

# The automatic passport scanners are slow because they're having trouble detecting
# which passports have all required fields. The expected fields are as follows:

# byr (Birth Year)
# iyr (Issue Year)
# eyr (Expiration Year)
# hgt (Height)
# hcl (Hair Color)
# ecl (Eye Color)
# pid (Passport ID)
# cid (Country ID)
# Passport data is validated in batch files (your puzzle input).
# Each passport is represented as a sequence of key:value pairs separated by spaces or newlines.
# Passports are separated by blank lines.

# Here is an example batch file containing four passports:

# ecl:gry pid:860033327 eyr:2020 hcl:#fffffd
# byr:1937 iyr:2017 cid:147 hgt:183cm

# iyr:2013 ecl:amb cid:350 eyr:2023 pid:028048884
# hcl:#cfa07d byr:1929

# hcl:#ae17e1 iyr:2013
# eyr:2024
# ecl:brn pid:760753108 byr:1931
# hgt:179cm

# hcl:#cfa07d eyr:2025 pid:166559648
# iyr:2011 ecl:brn hgt:59in

# The first passport is valid - all eight fields are present.
# The second passport is invalid - it is missing hgt (the Height field).

# The third passport is interesting; the only missing field is cid, so it looks like
# data from North Pole Credentials, not a passport at all! Surely, nobody would mind if you
# made the system temporarily ignore missing cid fields. Treat this "passport" as valid.

# The fourth passport is missing two fields, cid and byr. Missing cid is fine, but missing
# any other field is not, so this passport is invalid.

# According to the above rules, your improved system would report 2 valid passports.

# Count the number of valid passports - those that have all required fields. Treat cid as optional.
# In your batch file, how many passports are valid?

# --- Part Two ---
# The line is moving more quickly now, but you overhear airport security talking about
# how passports with invalid data are getting through. Better add some data validation, quick!

# You can continue to ignore the cid field, but each other field has strict rules about
# what values are valid for automatic validation:

# byr (Birth Year) - four digits; at least 1920 and at most 2002.
# iyr (Issue Year) - four digits; at least 2010 and at most 2020.
# eyr (Expiration Year) - four digits; at least 2020 and at most 2030.
# hgt (Height) - a number followed by either cm or in:
# If cm, the number must be at least 150 and at most 193.
# If in, the number must be at least 59 and at most 76.
# hcl (Hair Color) - a # followed by exactly six characters 0-9 or a-f.
# ecl (Eye Color) - exactly one of: amb blu brn gry grn hzl oth.
# pid (Passport ID) - a nine-digit number, including leading zeroes.
# cid (Country ID) - ignored, missing or not.

# Your job is to count the passports where all required fields are both present
# and valid according to the above rules. Here are some example values:

import re
from utils import read_file

FIELD_DELIMETER = " "
VALUE_DELIMITER = ":"

VALID_FIELDS = ["byr", "iyr", "eyr", "hgt", "hcl", "ecl", "pid"]

def get_passport_data(data):
  entries = data.split(FIELD_DELIMETER)
  data = {}
  for entry in entries:
    [field, value] = entry.split(VALUE_DELIMITER)
    data[field] = value
  return data

class Passport:
  EYE_COLORS = {"amb", "blu", "brn", "gry", "grn", "hzl", "oth"}
  HAIR_COLOR_REGEX = re.compile("^#[a-f0-9]{6}$")
  PID_REGEX = re.compile("^[0-9]{9}$")

  def __init__(self, byr=0, iyr=0, eyr=0, hgt='', hcl=None, ecl=None, pid=None, cid=None):
    height = hgt.replace('cm', '').replace('in', '')
    self.byr = int(byr)
    self.iyr = int(iyr)
    self.eyr = int(eyr)
    self.hgt = int(height) if height else 0
    self.hgt_unit = hgt[-2:]
    self.hcl = hcl
    self.ecl = ecl
    self.pid = pid

  def is_valid_byr(self):
    return 1920 <= self.byr <= 2002

  def is_valid_iyr(self):
    return 2010 <= self.iyr <= 2020

  def is_valid_eyr(self):
    return 2020 <= self.eyr <= 2030

  def is_valid_hgt(self):
    if self.hgt_unit == 'cm':
      return 150 <= self.hgt <= 193
    if self.hgt_unit == 'in':
      return 59 <= self.hgt <= 76
    return False

  def is_valid_hcl(self):
    return self.hcl and Passport.HAIR_COLOR_REGEX.match(self.hcl)

  def is_valid_ecl(self):
    return self.ecl in Passport.EYE_COLORS

  def is_valid_pid(self):
    return self.pid and Passport.PID_REGEX.match(self.pid)

  def is_valid(self):
    return (
      self.is_valid_byr() and
      self.is_valid_iyr() and
      self.is_valid_eyr() and
      self.is_valid_hgt() and
      self.is_valid_hcl() and
      self.is_valid_ecl() and
      self.is_valid_pid()
    )

def is_valid_passport(passport):
  return all([passport.get(field, False) for field in VALID_FIELDS])


if __name__ == "__main__":
  lines = read_file("day04_input.txt")

  valid_count = 0
  data_valid_count = 0
  passport = {}

  for line in lines:
    if line == "":
      if is_valid_passport(passport):
        valid_count += 1
      if Passport(**passport).is_valid():
        data_valid_count += 1
      passport = {}
    else:
      passport.update(get_passport_data(line))

  # check the last constructed passport
  if is_valid_passport(passport):
    valid_count += 1
  if Passport(**passport).is_valid():
    data_valid_count += 1

  print('Part 1 valid passports', valid_count)
  print('Part 2 valid passports', data_valid_count)
