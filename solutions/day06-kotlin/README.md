# Postmortem: First Day with Kotlin – Advent of Code Challenge
Coming from a Python-heavy background, with minimal exposure to Java from a university course over a decade ago, Kotlin
offered a mix of familiar and unfamiliar territory. Here’s how the day went:

## Initial Thoughts on Kotlin
Kotlin presented itself as a more modern and approachable cousin of Java, with a clean syntax and helpful features.
However, it was not as intuitive as Python, and I often found myself slowed down by its stricter typing and null-safety
mechanisms. While Kotlin’s design clearly aims to improve upon Java’s verbosity, there’s still a lot to learn before it
feels natural.

## Challenges Encountered
1. **Syntax and Structure:** Coming from Python, I found Kotlin’s syntax more verbose and less forgiving. For instance,
   defining function types explicitly seemed unnecessary:
   ```kotlin
   fun readInput(filePath: String): Array<CharArray>
   ```
   This felt like extra boilerplate compared to Python’s dynamic typing.
2. **Null Safety:** Kotlin’s null-safety system was both a blessing and a frustration. The need to deal with nullable
   types (`?`) or use the `!!` operator to assert non-nullability added complexity in places where Python would have
   let me move faster, even if less safely.
3. **Error Messages and Debugging:** Errors related to type mismatches or nullability were clear but sometimes felt
   excessive, particularly when experimenting or prototyping. For someone used to Python's forgiving nature, the
   rigidity of Kotlin required frequent pauses to adjust my mental model.
4. **Immutability and State Management:** The distinction between `val` (immutable) and `var` (mutable) variables was
   useful for clarity but required more upfront thinking. In a language like Python, I could iterate and refine
   quickly, while Kotlin forced me to slow down and commit to decisions earlier.
5. **Learning Curve with Classes:** Defining classes and enums, while more streamlined than in Java, still required
   more setup than I expected. It wasn’t difficult, but it was time-consuming compared to Python’s simple data
   structures.

## What Stood Out
1. **Collections and Functional Programming:** Kotlin's built-in collection methods (`map`, `filter`, `distinctBy`)
   made processing data straightforward. They were powerful and readable but felt more structured than Python’s list
   comprehensions.
   ```kotlin
   return uniquePositions.toList().distinctBy { it.coordinates }
   ```
   This kind of functionality was effective, though slightly less flexible than Python's dynamic handling of
   collections.
2. **Enums and Data Classes:** I appreciated the ability to define enums with methods (`Direction.next()`) and data
   classes with minimal effort:
   ```kotlin
   data class Position(var coordinates: Pair<Int, Int>, var direction: Direction)
   ```
   Compared to Java, this was a big improvement.
3. **Type Safety:** While frustrating at times, Kotlin’s strict type system helped catch mistakes early. It also forced
   me to be more deliberate in my approach, which could be an advantage in larger, more complex projects.
4. **Tooling and Error Prevention:** Working in Kotlin felt safe — once something compiled, it generally worked as
   expected. This is a contrast to Python, where runtime errors can sometimes crop up unexpectedly.

## Approach to the problem
The problem involved simulating a guard's movement based on a set of rules and determining the unique positions
visited. My solution was structured as follows:

1. Read the input as a 2D array of characters.
2. Parse the guard’s starting position and direction.
3. Define a `Guard` class to encapsulate movement logic and handle obstacles, boundaries, and direction changes.
4. Track all visited positions in a set for uniqueness.
5. Continue the simulation until the guard moved out of bounds, and count the distinct positions visited.

While Kotlin’s object-oriented features supported this approach well, the need for boilerplate and strict typing made
the process slower than I’d have liked.

## Kotlin Compared to Python and Java
| Feature | Python | Kotlin | Java |
|---------|--------|--------|------|
| Syntax | Minimal, flexible | Structured but concise | Verbose, requires boilerplate |
| Null Handling | None with runtime checks | Null safety at compile time | Manual checks or exceptions |
| Data Structures | Flexible, quick setup | Powerful but rigid | Primitive-heavy, cumbersome setup |
| Error Prevention | Runtime safety varies | High at compile time | High at compile time |
| Ease of Use | Fast to prototype | Slower but deliberate | Steep learning curve|

## Would I Use Kotlin Again?
Probably, but selectively. For projects where safety, performance, and maintainability are critical, Kotlin could be a
strong choice. However, for quick scripts or exploratory tasks, I’d likely stick to Python for its simplicity and speed
of iteration.

## Final Thoughts
Kotlin was a mixed bag for me. On one hand, its modern features and safety mechanisms were nice, especially
compared to Java. On the other hand, the stricter environment and verbose setup felt like hurdles for someone used to
Python's lightweight approach.

For today’s problem, Kotlin worked well enough, but it didn’t feel like the most efficient tool for the job. While I
wouldn’t rush to use it again for simple tasks, I see its potential for more complex and structured applications.
Overall, it was a decent learning experience but not without its frustrations.
