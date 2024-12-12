# Postmortem: Advent of Code Day 4 - Ruby

## First Impressions of Ruby
This was my first day working with [Ruby](https://www.ruby-lang.org/en/), and I have to say it was a fascinating
experience. Coming from a Python-heavy background, particularly in automotive and machine learning contexts, diving
into Ruby felt like stepping into a more conversational, expressive, and opinionated language. It’s clear that Ruby
prioritizes developer happiness, and its design encourages writing elegant and concise code. That said, there were some
challenges and surprises along the way.

## Challenges Faced
1. **Implicit Conventions**: Ruby’s reliance on implicit behavior caught me off guard a few times. For example, the
   pervasive use of blocks (&:method) and chaining methods like .map(&:chomp) was kind of overwhelming.
   It’s elegant but requires a deeper understanding of Ruby idioms to avoid feeling lost.
2. **Enumerable Wizardry**: Ruby’s `Enumerable` module is a powerhouse, and it made me rethink some Python habits.
   While Python’s list comprehensions and generator expressions are intuitive for me, Ruby’s `.map`, `.sum`, and
   `.each_with_index` felt like unlocking new ways to approach problems. However, the sheer number of methods available
   was initially confusing.
3. **String Manipulation**: Coming from Python, where strings are immutable and you rely on libraries like `re` for
   regex, Ruby’s built-in regex capabilities and chaining methods like `.scan` felt fluid but unfamiliar. I needed some
   trial and error to get comfortable with how Ruby handles pattern matching and scanning.
4. **Transposing Arrays**: Implementing the vertical and diagonal checks required some digging into Ruby’s array
   capabilities. Using `.transpose` for vertical counting was clever but non-obvious to a Python developer accustomed
   to `zip(*array)`.

## Interesting Observations
1. **Blocks Everywhere**: Ruby’s block syntax is delightful. The ability to pass chunks of logic directly into methods
   like `.each_with_index` or `.map` makes the code read like prose. It’s similar to Python’s list comprehensions but
   feels more customizable and expressive.
2. **Pervasive Symbols**: Ruby's use of symbols (e.g., `:chomp`) as lightweight, immutable identifiers was interesting.
   It reminds me of enums or named constants in Python but is used in everyday contexts for performance and clarity.
3. **Frozen Constants**: Declaring constants like `XMAS_PATTERN` with `.freeze` was new to me. It’s a nice safeguard
   for ensuring immutability in a mutable world. Python doesn’t have a direct equivalent but relies on naming
   conventions for constants (`UPPERCASE_NAMES`).
4. **Ruby Gems**: While I didn’t use any gems today, it’s worth noting that Ruby’s ecosystem feels polished. It made me
   curious about exploring gems like Rails for web development.

## Good Learning Experiences

### Regex Integration
Ruby’s seamless integration of regex into its core methods like `.scan` was a revelation. I didn’t have to import a
module or write verbose code. This will stick with me as one of Ruby’s strongest features.

### Functional Thinking
Ruby’s chainable methods and block-based approach encouraged me to think more functionally. Instead of iterative loops,
I wrote compact and declarative transformations.

### Code Organization
Structuring the program into small, reusable methods (`horizontal_count`, `vertical_count`, etc.) felt very Ruby-esque.
It reinforced the importance of clean, modular design.

## Comparisons to Python

| Aspect | Ruby | Python |
| ------ | ---- | ------ |
| **Readability** | Ruby reads like a natural language but has more magic. | Python is straightforward and explicit, favoring clarity. |
| **Flexibility** | Ruby offers incredible method chaining and DSL-like elegance. | Python prioritizes simplicity over expressiveness. |
| **Community & Ecosystem** | Ruby’s gems are polished, but Python dominates in libraries. | Python’s ecosystem is unparalleled, especially for ML and AI. |
| **Development Experience** | Ruby feels fun and opinionated. | Python feels versatile and pragmatic. |
| **Performance** | Ruby felt slower during iterations compared to Python. | Python has similar limitations but performs better in many cases. |


## Would I Use Ruby Again?

Ruby’s syntax and philosophy are delightful for writing concise, readable code, and it’s easy to see why it’s a
favorite for web development with frameworks like Rails. That said, its ecosystem and performance aren’t as suited for
tasks I usually encounter, like data processing or machine learning. For a scripting-heavy domain or a side project
focused on clean, expressive code, Ruby would be an enjoyable choice.

This experience also reaffirmed my appreciation for Python’s explicitness and versatility. While Ruby feels like
poetry, Python feels like a reliable toolkit—unadorned but powerful. I’ll carry some Ruby idioms back to my Python
code, particularly around organizing reusable methods and thinking more functionally.

## Closing Thoughts

Advent of Code continues to be a fantastic way to explore languages. Ruby challenged me to think differently and pushed
me out of my Python comfort zone. While Ruby might not replace Python in my professional work, it has earned my respect
as a beautiful, expressive language for solving problems like today’s puzzle.

