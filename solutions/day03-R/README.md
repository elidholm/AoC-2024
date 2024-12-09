# Postmortem: My Day Wokring in R for Advent of Code

Todays Advent of Code-problem was tackled using [R](https://www.r-project.org/). As someone who spent a lot of time
working in Matlab during school and has most of my profesisonal experience in Python, this was a fun change of pace.
Here are my thoughts:

## Challenges
* **File handling**: the first hurdle I ran into was R's approach to file handling. Coming from Python, where I'm
  used to working with `pathlib` and `os`, I found R's way of setting the working directory and getting file paths a
  bit different. In Python, I can just rely on `os.path`, but in R, I had to use functions like `setcwd()` and
  `rstudioapi::getActiveDocumentContext()` to get the right file path context. It took a minute to adjust, but I
  got there.
* **Syntax**: R’s syntax, especially for functional programming, was a bit tricky for me. I’m really comfortable with
  Python’s list comprehensions and built-in functions like `map()` and `filter()`. In R, the equivalent functionality
  exists through functions like `lapply()` and `sapply()`, but the syntax felt a little less intuitive at first. The pipe
  operator (`|>`) is great for chaining functions together, but I had to get used to it after Python’s more familiar
  functional approach.

## What I Found Interesting
* **String manipulation**: One of the coolest things about R is how it handles strings. The `stringr` package is
  excellent for regex-based operations, and I found it quite handy in a regex-esque challenge like today's puzzle. The
  ability to quickly extract and manipulate substrings with `str_extract_all()` was powerful.
* **Functional programming**: While R’s approach to functional programming took a bit of getting used to, I started to
  really appreciate how clean and expressive it made my code. The `|>` pipe operator allowed me to chain operations
  together in a way that felt pretty natural, even if it’s a bit different from Python's functional approach.

## R vs. Python vs. Matlab: How They Compare
1. **R vs. Python**:
    * **Libraries**: Python's libraries for general-purpose tasks, web development, and machine learning are much more
      robust. R's strength lies in data analysis and statistical modeling, si if I were working on something like that,
      R would definitely shine.
    * **Syntax**: Python's syntax is more flexible and familiar, especially for general programming. R is more rigid
      and functional, but that's not necessarily a bad thing - just something to get used to.
    * **Community**: Python's community is huge and diverse, covering everything from web development to machine
      learning. R's community is smaller but really focused on data science and statistics, which can be a big plus in
      that space.
2. **R vs. Matlab**:
    * **Syntax**: R and Matlab share some similarities, especially when it comes to matrix operations. R feels more
      flexible, though with a broader range of data structures (like tibbles and data frames). Matlab, on the other
      hand, feels more rigid and specialized for numerical computations.
    * **Data manipulation**: Matlab is great for numerical tasks but less focused on string manipulation and
      general-purpose data handling. R's syntax and packages like `stringr` make text menipulation much easier, and its
      ecosystem feels more modern.
    * **Tooling**: Matlab is a proprietary tool, whereas R has open-source alternatives like RStudio, which I found to
      be an OK development environment. It made coding in a new language like R much easier and more intuitive with
      the extra help an IDE can give you compared to my everyday editor, Vim.

## Would I Use R Again?
While I don’t see myself switching to R for general-purpose programming or machine learning projects anytime soon, I
can definitely see myself using it for data-centric tasks, especially in research or when working with large datasets.
R’s ecosystem is fantastic for statistical analysis, and the functional style it promotes is something I’d like to
explore further.

Overall, today was a great experience. It was a fun challenge to step outside my usual languages and explore something
new. I’m looking forward to tackling more Advent of Code problems in different languages - it’s a good way to expand my
coding toolkit!
