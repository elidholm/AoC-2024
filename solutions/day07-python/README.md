# Postmortem: Python, Ye Olde Friend!
For today’s Advent of Code challenge, I got Python, the language I’m most experienced with. It was a deliberate choice
to include multiple days of Python to make some days easier amidst a challenge that otherwise involves learning a new
language every day. However, instead of sticking to familiar patterns, I used the opportunity to explore Python's CLI
capabilities and improve my approach to logging, areas where I felt I could deepen my skills.

## Approach to the Problem
The challenge revolved around determining if sequences of numbers could be combined with specified operators (`+`, `*`,
and concatenation `||`) to produce a target value. To solve this:
1. **Input Parsing:** I structured the input as a list of `Equation` objects, each encapsulating the target value and
   operands. This abstraction made the problem easier to manage and modularized the solution.

2. **Recursive Evaluation:** A recursive function (`_is_solvable`) checked whether an equation could be solved using
   left-to-right evaluation of operators. This allowed the solution to systematically explore all operator combinations
   while adhering to the problem constraints.

3. **CLI and Logging:** I added a command-line interface to handle input files and a debug flag for verbosity. Enhanced
   logging with `rich.logging` helped track progress, errors, and the reasoning behind each step.

4. **Summation of Valid Equations:** If an equation was solvable, its target value was added to the total calibration
   result. This was the final output for the engineers in the puzzle context.

## Solution Highlights
* **Modular Class Design:** The `Equation` class served as the core abstraction. It included methods for recursive
  solvability checks and clear string representations for debugging:
  ```python
  class Equation:
      def __init__(self, target_value, operands):
          self.target_value = target_value
          self.operands = operands
  ```
* **Recursive Solver:** The `_is_solvable` method handled all operator combinations:
  ```python
  def _is_solvable(self, operands: List[int]) -> bool:
      if len(operands) == 1:
          return operands[0] == self.target_value
      return (
          self._is_solvable([operands[0] + operands[1]] + operands[2:]) or
          self._is_solvable([operands[0] * operands[1]] + operands[2:]) or
          self._is_solvable([int(str(operands[0]) + str(operands[1]))] + operands[2:])
      )
  ```
  This approach ensured a systematic exploration of all valid operator placements.

* **Command-Line Interface:** Using `argparse`, I provided options to enable debug logging and specify input files,
  making the script flexible for different use cases.

* **Advanced Logging:** Using the fancy `rich.logging` log handler, the logs were more readable, and debug-level logs
  gave detailed insights into equation evaluation.


## Challenges Faced
The recursive approach, while clear and correct, was not optimized for larger input sizes. Python’s lack of tail-call
optimization meant that excessive recursion depth could lead to performance bottlenecks. Also, when handling
concatenation (`||`) required converting integers to strings and back. While straightforward in Python, this felt
inelegant compared to operations on purely numerical values. Lastly, even with experience in Python, the recursive
nature of the problem made debugging tricky. The improved logging mitigated this somewhat, but there was room for
better visualization tools.

## Would I do Anything Differently?
For future iterations:

* I’d explore non-recursive approaches to handle operator combinations, especially for larger input sizes.
* Adding a visual representation of the recursion tree in the debug logs might have been helpful.
* For scalability, I’d consider tools like `multiprocessing` or `asyncio` to handle equation evaluation concurrently.

## Final Thoughts
Using Python was a comfortable change of pace in this challenge. It allowed me to focus less on syntax and more on
refining the solution’s structure and usability. While the day felt less adventurous compared to learning a new
language, it provided an opportunity to polish areas I don’t always prioritize in everyday work, such as CLI design and
logging.
