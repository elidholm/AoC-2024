# Set working directory to the script's location
setwd(dirname(rstudioapi::getActiveDocumentContext()$path))

parse_input <- function(file_path) {
  if (!file.exists(file_path)) {
    stop("Input file not found!")
  }
  readLines(file_path)
}

process_instructions <- function(input_data) {
  # Extract all 'mul(x, y)' instructions
  instructions <- stringr::str_extract_all(input_data, "mul\\(\\d+,\\d+\\)") |> unlist()

  # Extract numeric values, convert to integers, compute products, and sum them
  stringr::str_extract_all(instructions, "\\d+") |>
    lapply(as.integer) |>
    sapply(prod) |>
    sum()
}

# Main script execution
input_file <- "input.txt"
input_data <- parse_input(input_file)

result <- process_instructions(input_data)

cat("The sum of all products is:", result, "\n")
