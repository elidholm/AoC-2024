# Set working directory to the script's location
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

parse_input <- function(file_path) {
  if (!file.exists(file_path)) {
    stop("Input file not found!")
  }
  readLines(file_path)
}

process_instructions <- function(instructions) {
  # Extract relevant instructions (mul, do, don't)
  parsed_instructions <- stringr::str_extract_all(instructions, "mul\\(\\d+,\\d+\\)|do\\(.*?\\)|don't\\(.*?\\)") |>
    unlist()

  # Initialize filter state
  enabled <- TRUE

  # Process each instruction and filter based on "do" and "don't" directives
  for (i in seq_along(parsed_instructions)) {
    if (grepl("^do\\(\\)", parsed_instructions[i])) {
      enabled <- TRUE
      parsed_instructions[i] <- ""
    } else if (grepl("^don't\\(\\)", parsed_instructions[i])) {
      enabled <- FALSE
      parsed_instructions[i] <- ""
    }

    # Remove instructions if filtering is disabled
    if (!enabled) {
      parsed_instructions[i] <- ""
    }
  }

  # Return filtered instructions
  parsed_instructions[parsed_instructions != ""]
}

calculate_sum_of_products <- function(filtered_instructions) {
  filtered_instructions |>
    stringr::str_extract_all("\\d+") |>
    lapply(as.integer) |>
    sapply(prod) |>
    sum()
}

# Main script execution
input_file <- "input.txt"
input_data <- parse_input(input_file)

filtered_instructions <- process_instructions(input_data)
result <- calculate_sum_of_products(filtered_instructions)

cat("The sum of all valid products is:", result, "\n")
