#!/usr/bin/env ruby
# frozen_string_literal: true

# Define X-shaped "MAS" patterns
XMAS_PATTERNS = [%w[M M S S], %w[M S M S], %w[S M S M], %w[S S M M]].freeze

# Read and parse input lines into a grid
def input_grid
  @input_grid ||= begin
    grid = {}
    File.readlines(File.join(__dir__, 'input.txt')).each_with_index do |line, y_index|
      line.chomp.chars.each_with_index { |char, x_index| grid[[x_index, y_index]] = char }
    end
    grid
  end
end

# Extract corner values around a given position (x_index, y_index)
def corners(x_index, y_index)
  [
    input_grid[[x_index - 1, y_index - 1]],
    input_grid[[x_index + 1, y_index - 1]],
    input_grid[[x_index - 1, y_index + 1]],
    input_grid[[x_index + 1, y_index + 1]]
  ]
end

# Check if the corners match any of the XMAS patterns
def xmas_match?(x_index, y_index)
  XMAS_PATTERNS.any? { |pattern| corners(x_index, y_index) == pattern }
end

# Count the amount of "A" nodes that satisfy the XMAS condition
def count_xmas_matches
  input_grid.count do |(x_index, y_index), value|
    value == 'A' && xmas_match?(x_index, y_index)
  end
end

# Output the result
puts "Result: #{count_xmas_matches}"
