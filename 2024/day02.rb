# Determine which lines are safe
# 1) line must contain numbers that all increasing or decreasing
# 2) adjacent numbers differ by 1, 2, or 3, meaning adjacent numbers cannot be equal
class Day2
  def initialize
    @safe_reports = 0
    @safe_reports_with_dampening = 0
  end

  def call
    filename = File.join(File.dirname(__FILE__), 'day02_input.txt')
    IO.foreach(filename) do |line|
      @safe_reports += 1 if safe_report?(line:)
      @safe_reports_with_dampening += 1 if safe_reports_with_dampening(line:)
    end

    puts "safe reports: #{@safe_reports}"
    puts "safe reports with dampening: #{@safe_reports_with_dampening}"
  end

  private

  def safe_report?(line:)
    report = line.split(' ').map(&:to_i)
    increases?(report:) || decreases?(report:)
  end

  def safe_reports_with_dampening(line:)
    report = line.split(' ').map(&:to_i)
    increases?(report:) || decreases?(report:) || with_dampening(report:)
  end

  def with_dampening(report:)
    (0..report.length - 1).to_a.any? do |index|
      modified_report = report.reject.with_index { |_, i| i == index }
      increases?(report: modified_report) || decreases?(report: modified_report)
    end
  end

  def increases?(report:)
    i = 0
    while i < report.length - 1
      diff = report[i + 1] - report[i]
      safe = [1, 2, 3].include?(diff)

      return false unless safe

      i += 1
    end

    true
  end

  def decreases?(report:)
    i = 0
    while i < report.length - 1
      diff = report[i] - report[i + 1]
      safe = [1, 2, 3].include?(diff)

      return false unless safe

      i += 1
    end

    true
  end
end

Day2.new.call
