#!/usr/bin/env ruby
# frozen_string_literal: true

# Pattern to match "XMAS" and "SAMX"
XMAS_PATTERN = /(?=(XMAS|SAMX))/.freeze
PADDING_CHAR = '.'

# Read input lines from the txt file
def input_lines
  @input_lines ||= File.readlines(File.join(__dir__, 'input.txt')).map(&:chomp)
end

# Count occurrences of the XMAS pattern in a given string
def count_xmas(line)
  line.scan(XMAS_PATTERN).count
end

# Count horizontal occurences of XMAS in each line
def horizontal_count
  input_lines.sum { |line| count_xmas(line) }
end

# Count vertical occurences by transposing the input
def vertical_count
  input_lines.map(&:chars).transpose.map(&:join).sum { |line| count_xmas(line) }
end

# Generalized method for counting diagonal occurences
def diagonal_count(&pad_block)
  padded_lines = input_lines.map(&:chars).each_with_index.map(&pad_block)
  padded_lines.transpose.map(&:join).sum { |line| count_xmas(line) }
end

# Count occurrences of XMAS in descending diagonals
def descending_count
  diagonal_count do |line, i|
    Array.new(input_lines.size - i, PADDING_CHAR) + line + Array.new(i, PADDING_CHAR)
  end
end

# Count occurrences of XMAS in ascending diagonals
def ascending_count
  diagonal_count do |line, i|
    Array.new(i, PADDING_CHAR) + line + Array.new(input_lines.size - i, PADDING_CHAR)
  end
end

# Compute the total result
def total_count
  horizontal_count + vertical_count + descending_count + ascending_count
end

# Output the result
puts "Result: #{total_count}"
