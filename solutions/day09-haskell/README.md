# Postmortem: Advent of Code Day 9 in Haskell
Today marked my first dip of the toes into Haskell as part of my "Advent of Code in a new language every day" challenge.
Previously, my only exposure to functional programming had been a couple of days ago in Scala. My background is
predominantly in Python, particularly in automotive and machine learning contexts, so tackling Haskell with no prior
experience in such a rigorously functional language was... enlightening.

## Challenges
#### Syntax and Concepts
* Haskell's syntax and paradigm were the steepest learning curve of the day. Concepts like immutability, purity, and
  lazy evaluation, though familiar from Scala, were far more strictly enforced in Haskell.
* Even seemingly simple tasks, like parsing strings into structured data, felt verbose and complex compared to Python.

#### Tooling and Ecosystem
* Setting up the Haskell environment (e.g., GHC, Cabal/Stack) took longer than anticipated. While tools exist, they
  feel less intuitive compared to the seamless environment provided by Python's ecosystem.

#### Debugging
* Error messages were cryptic, especially for someone new to the language. Understanding type mismatches or why a
  particular function failed required significant effort.
#### Mental Model Shift
* Thinking in terms of recursion and higher-order functions, rather than loops and mutable state, was challenging.
  Python and Scala both allow imperative-style constructs, but Haskell forces a purely functional approach.

## What Was Interesting
#### Pattern Matching and Type Safety
* Once I wrapped my head around pattern matching, it became a powerful tool for deconstructing data structures.
  Combined with Haskell's strong type system, it ensured my functions were robust.

#### Elegance in Functional Composition
* Despite initial struggles, I appreciated the composability of functions. Chaining transformations in Haskell felt
  clean once the logic was clear.

#### Laziness
* Haskell's lazy evaluation was fascinating. Knowing that operations wouldn't compute until explicitly required helped
  optimize performance in some parts of my solution.

## Comparisons
### Haskell vs. Python
* **Python** is far more approachable for quick prototyping and intuitive to read/write. The dynamic typing in Python
  feels liberating compared to Haskell's rigidity, but this rigidity has its advantages in catching errors at compile
  time.
* Tasks that would take a few lines in Python felt verbose in Haskell. However, Haskell's solutions often felt more
  robust and mathematically sound once completed.

### Haskell vs. Scala
* **Scala** bridges the gap between functional and imperative programming, making it more accessible to developers
  transitioning from object-oriented languages. It allowed me to write functional code but didn’t enforce it as
  strictly as Haskell.
* Haskell, being purely functional, provided a more "authentic" experience of functional programming, but it also made
  simple tasks more convoluted compared to Scala.

## What Will I Carry With Me in the Future?
1. **Pure Functional Programming:** Writing a purely functional program helped solidify concepts that were abstract in
   Scala.
2. **Type-Driven Development:** Haskell's type system encouraged thinking about the structure of data and operations
   more rigorously.
3. **New Tools:** Learning to use GHC and the nuances of Haskell's tooling broadened my skill set.

## Final Thoughts
Would I use Haskell again? For another Advent of Code challenge or as a learning exercise, certainly. However, I
wouldn't reach for Haskell as a go-to language for general-purpose programming. It was an excellent exercise in
functional programming, but the overhead for setup, learning, and debugging outweighs its advantages for my usual
workflows.

If I ever tackle a project requiring a purely functional paradigm or high levels of type safety, Haskell might enter
the conversation. But for now, I'll stick with Python's simplicity for production work.

Tomorrow, a new language! Let's see where the challenge takes me next.
