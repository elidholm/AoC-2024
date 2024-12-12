# Postmortem: Advent of Code Day 5 - TypeScript

## First Impressions of TypeScript
Diving into [TypeScript](https://www.typescriptlang.org/) for the first time was both enlightening and humbling. Having
some prior exposure to JavaScript via a simple React project, I thought I might breeze through the syntax. However,
TypeScript's emphasis on strong typing and its additional features turned what could have been a JavaScript problem
into an entirely different development experience.

## Challenges Faced
1. **Type System Learning Curve**: Coming from Python, where dynamic typing reigns supreme, adapting to TypeScript's
   type annotations and type inference was a significant shift. Declaring types for more complex data structures like
   `Rule` and `Update` was a bit tedious at first, though it ultimately improved the code clarity.
2. **File System Module**: Reading the input file using Node.js's `fs` module felt verbose compared to Python’s
   straightforward `open` function. While I understand the modular design philosophy, it initially felt like
   unnecessary boilerplate for something so simple.
3. **Type Annotations Everywhere**: Balancing when to rely on TypeScript's type inference and when to explicitly
   annotate was tricky. For example, while TypeScript inferred the return type of `readLines` correctly, other areas
   like `parseInput` required more explicit declarations to avoid errors.
4. **Strictness in Iteration and Array Manipulation**: Working with arrays in TypeScript required more care than in
   Python. The need to ensure types were consistent (e.g., using `string[]` or `[string, string]`) slowed me down when
   chaining transformations or accessing elements.

## Interesting Observations
1. **Type Safety**: While initially a hurdle, TypeScript's type system turned out to be one of its greatest strengths.
   By defining clear types for `Rule` and `Update`, I avoided bugs that might have slipped through in a dynamically
   typed language. This type safety would be invaluable for large projects.
2. **Functional Programming Support**: TypeScript's support for higher-order functions like `.map`, `.reduce`, and
   `.filter` felt familiar coming from Python. However, the stricter type requirements meant I had to be more
   deliberate about how I transformed and aggregated data.
3. **Verbose but Clear Error Messages**: TypeScript's compiler errors were verbose but incredibly helpful. When I made
   mistakes, the error messages often suggested exactly how to fix them—a refreshing change compared to the sometimes
   cryptic errors in JavaScript or Python.

## Good Learning Experiences
* **Working with Types**: Defining `Rule` as `[string, string]` and `Update` as `string[]` forced me to think
  explicitly about the structure of my data. This experience reinforced the value of thinking about data shapes
  upfront, a habit I’ll carry into future Python projects.
* **Breaking Down the Problem**: TypeScript’s stricter syntax encouraged me to break the problem into smaller,
  well-defined functions. While I do this in Python as well, the need to explicitly type inputs and outputs made me
  more disciplined.
* **Better Understanding of JavaScript**: Since TypeScript builds on JavaScript, I deepened my understanding of
  JavaScript fundamentals. Concepts like destructuring, template literals, and modular imports became second nature
  during this exercise.

## Comparisons to Python

| **Aspect**             | **TypeScript**                                                  | **Python**                                                     |
|-------------------------|-----------------------------------------------------------------|----------------------------------------------------------------|
| **Typing**              | Static typing enhances safety and scalability.                 | Dynamic typing allows for quick prototyping.                  |
| **Readability**         | Clear with types but more verbose than Python.                 | Concise and beginner-friendly.                                |
| **Tooling**             | Excellent IDE support and real-time feedback.                  | Strong but less integrated out-of-the-box.                    |
| **Array Manipulation**  | Requires explicit type handling, which can be verbose.         | Flexible and intuitive for quick iterations.                  |
| **Performance**         | Comparable, but requires a build step for execution.           | No build step; runs directly.                                 |

## Would I Use TypeScript Again?

Absolutely! TypeScript offers a level of confidence that is hard to match, especially for medium-to-large-scale
projects where maintainability and team collaboration are critical. Its robust type system and integration with modern
development tools make it a strong choice for projects requiring front-end or back-end JavaScript.

That said, for quick one-off scripts or data-heavy tasks in domains like machine learning or automotive diagnostics,
Python remains my go-to due to its simplicity and extensive libraries.

## Final Thoughts

Advent of Code Day 5 was a great introduction to TypeScript. It forced me out of my comfort zone, taught me the value
of type safety, and highlighted the importance of thoughtful data design. While it may not replace Python for my
everyday tasks, TypeScript has earned a place in my toolkit—particularly for web development or collaborative projects.
It’s a language I’ll likely return to for deeper exploration.
