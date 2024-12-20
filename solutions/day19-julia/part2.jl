# Recursive function to check if a design can be constructed using patterns
function create_towel(design::SubString{String}, patterns::Vector{SubString{String}}, cache::Dict{String, Int})::Int
    if design == "" # Base case: empty design
        return 1
    end

    return get!(cache, design) do
        valid_patterns = filter(pattern -> startswith(design, pattern), patterns)
        sum([create_towel(design[length(pattern)+1:end], patterns, cache) for pattern in valid_patterns])
    end
end

# Function to parse input data into patterns and designs
function parse_input(input::String)::Tuple{Vector{SubString{String}}, Vector{SubString{String}}}
    parts = split(input, "\n\n", limit=2)
    if length(parts) != 2
        error("Invalid input format")
    end
    patterns = split(parts[1], ", ")
    designs = split(strip(parts[2]), "\n")
    return patterns, designs
end

# Main function to compute the number of possible designs
function main()
    # Read input from the file
    input_file = "input.txt"
    input_content = read(input_file, String)

    # Parse input into patterns and designs
    patterns, designs = parse_input(input_content)

    # Initialize cache
    cache = Dict{String, Int}()

    # Count the number of possible designs
    possible_designs = sum(create_towel(design, patterns, cache) for design in designs)

    # Output the result
    println("Number of possible designs: $possible_designs")
end

# Run the main function if the script is executed directly
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
