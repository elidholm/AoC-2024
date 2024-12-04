# Post-Mortem: Day 2 of Advent of Code in Scala

Today was my first encounter with Scala, as part of my Advent of Code
challenge to solve each day's puzzle in a different language. My programming
background is primarily in Python, both for automotive and machine learning
projects, with some low-level experience from last year's AoC in Rust. Scala,
with its mix of object-oriented and functional paradigms, was an entirely new
experience for me. Here's a breakdown of the day:

## Challenges
1. **Syntax and Semantics**: Coming from Python, Scala's syntax wasn't a
   steep learning curve. The heavy use of `val` and `def`, indentation-based
   syntax (like in Python), and some quirks like `forall` or `sliding`
   methods in collections required some reference to the documentation.

2. **Functional Programming Concepts**: Scala is inherently more functional
   than Python. Concepts like immutability, higher-order functions, and
   pattern matching were fascinating but initially daunting. Writing a
   solution that leaned on these paradigms rather than imperative coding took
   some effort.

3. **Type Safety**: While Rust's type system had prepared me for strict
   typing, Scala's type inference and implicit conversions sometimes felt
   unintuitive. Errors about mismatched types (e.g., `Seq[List[Int]]` vs.
   `List[List[Int]]`) tripped me up.

4. **Error Messages**: Scala's error messages were not as verbose or
   beginner-friendly as Python's. Debugging was more time-consuming,
   especially when working with nested collections

## Interesting Observations
1. **Powerful Collections API**: Scala's `List`, `Seq`, and other collections
   are incredibly expressive. Methods like `sliding`, `map`, and `forall`
   allowed me to write concise solutions, albeit after spending time
   understanding their usage.

2. **Interoperability**: The seamless ability to call Java libraries was a
   pleasant surprise. For example, using `scala.io.Source` for file I/O felt
   modern and powerful.

3. **Conciseness**: Compared to Python, Scala allowed for extremely compact
   code without sacrificing readability. Once I got used to it, I appreciated
   how Scala encourages elegant expressions of logic.

4. **Modern Syntax**: The indentation-based syntax in Scala 3.6.1 felt more
   approachable than older versions I saw with braces everywhere. It reminded
   me of Python's readability-first philosophy.

## Learning Experience
* **Functional Thinking**: Scala forced me to embrace immutability and
  functional patterns. I had to think about transformations (`map`) rather
  than loops, which was an excellent mental workout.
* **Error Handling**: The use of exceptions in file reading
  (`Source.fromFile`) and functional methods (map`) gave me a glimpse into
  Scala's dual nature — bridging traditional OOP with functional approaches.
* **Pattern Matching**: Scala 's `case` syntax for destructuring in the
  `sliding` function was welcome. It’s much cleaner than manual index access
  in Python.

## Comparing Scala and Python
1. **Expressiveness**: Python's simplicity is unbeatable for quick
   prototyping, but Scala's collection APIs and functional tools allow for
   extremely concise code. Once I understood the syntax, Scala felt more
   powerful for abstract manipulations.

2. **Community and Documentation**: Scala’s community resources and
   documentation felt more niche compared to Python's vast ecosystem. As a
   newcomer, finding answers was harder than in Python.

3. **Type Safety**: Coming from Python's dynamic typing, Scala's static type
   system felt burdensome at first but later became an ally, preventing bugs
   and clarifying intent.

## Would I Use Scala Again?
Absolutely, but with reservations. For tasks requiring complex data
transformations or needing both functional and OOP paradigms, Scala is a
compelling choice. However, I wouldn't pick it over Python for quick scripts
or Machine Learning due to its steeper learning curve and verbose setup.
That said, Scala seems perfect for backend services as far as I can tell, big
data processing (e.g., Spark), or any domain where type safety and
performance are paramount.

## Final Thoughts
Scala pushed me out of my comfort zone in the best way possible. It was a
humbling experience but one that reinforced valuable concepts like
immutability, functional programming, and type systems. While challenging,
it felt like a step forward in becoming a more versatile developer.

*Advent of Code in Scala: tough but rewarding!*
