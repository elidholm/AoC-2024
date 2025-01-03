# Advent of Code Post-Mortem: Day 8 (Python)
iFor the second day in a row, the wheel of chance assigned me Python for the Advent of Code challenge. Given my
extensive background in Python, this wasn't an opportunity to learn a new language but rather a chance to refine
techniques I don’t typically use in my professional work. I decided to build on yesterday’s progress by further
exploring Python CLI development and advanced logging practices.

## Problem Breakdown
The problem required calculating unique "antinodes" within a grid based on the positions of antennas. Each antenna,
represented by a unique frequency (letters, digits, etc.), could generate antinodes under certain conditions:

* **Part 1:** Antinodes occur only when one antenna is twice as far as another, along a straight line.
* **Part 2:** Antinodes occur wherever any two antennas of the same frequency align, regardless of distance.

Both parts relied on geometric reasoning and grid-based iteration. The complexity came from the need to scale the
solution efficiently as grids and antenna counts increased.

## Approach
1. **Input Parsing** The input grid was parsed into a list of strings, where each character represented either an
   antenna or empty space. This straightforward representation allowed easy indexing and manipulation.

2. **Antenna Extraction** Antenna positions were extracted and categorized by frequency. I used a dictionary to map
   each frequency to a list of its coordinates, which kept the process clean and fast.

3. **Antinode Calculation** The main logic revolved around finding all unique antinodes:
   * For each pair of antennas of the same frequency, I calculated the vector difference `(dx, dy)` between them.
   * Using this vector, I iterated through the grid in both directions, marking positions as antinodes until hitting
     the grid boundary.

The most challenging aspect was ensuring every position was processed without duplicating logic or recalculating
redundant vectors.

## Python Techniques Explored
* **CLI with Argument Parsing** I used `argparse` to build a script that could toggle between standard and debug
  logging modes. This feature allowed me to focus on correctness during development and gain deeper insights into edge
  cases by enabling verbose logs.

* **Advanced Logging** Using the `rich` library for structured logging was a rewarding choice. The colored output and
  timestamped messages made it easier to debug grid-related issues and track progress in dense loops.

* **Set Operations** To track unique antinodes efficiently, I used Python’s `set`. This ensured that no matter how many
  redundant calculations occurred, the final result contained only unique coordinates.

## Final Thoughts
Solving this challenge in Python felt like revisiting an old friend — familiar and reliable but with room to discover
new things. While I didn’t face the same learning curve as with other languages, refining my approach to Python
scripting and logging was a valuable experience.

Tomorrow, it’s time to spin the wheel again and dive into the next language!
