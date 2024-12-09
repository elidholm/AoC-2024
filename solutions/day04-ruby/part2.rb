#!/usr/bin/env ruby
# frozen_string_literal: true

# Define X-shaped "MAS" patterns
XMAS_PATTERNS = [%w[M M S S], %w[M S M S], %w[S M S M], %w[S S M M]].freeze

# Read and parse input lines into a grid
def input_grid
  @input_grid ||= begin
    grid = {}
    File.readlines(File.join(__dir__, 'input.txt')).each_with_index do |line, y|
      line.chomp.chars.each_with_index { |char, x| grid[[x, y]] = char }
    end
    grid
  end
end

# Extract corner values around a given position (x, y)
def corners(x, y)
  [
    input_grid[[x - 1, y - 1]],
    input_grid[[x + 1, y - 1]],
    input_grid[[x - 1, y + 1]],
    input_grid[[x + 1, y + 1]]
  ]
end

# Check if the corners match any of the XMAS patterns
def xmas_match?(x, y)
  XMAS_PATTERNS.any? { |pattern| corners(x, y) == pattern }
end

# Count the amount of "A" nodes that satisfy the XMAS condition
def count_xmas_matches
  input_grid.count do |(x, y), value|
    value == 'A' && xmas_match?(x, y)
  end
end

# Output the result
puts "Result: #{count_xmas_matches}"
