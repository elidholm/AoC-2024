# Utility function to calculate the number of digits in an integer
function number_of_digits(x::Int)::Int
    return floor(Int, log10(x) + 1)
end

# Transformation rules for each stone during a "blink"
function blink(x::Int)
    if x == 0
        return 1
    elseif number_of_digits(x) % 2 == 0
        return divrem(x, 10^(number_of_digits(x) ÷ 2))
    else
        return x * 2024
    end
end

# Recursive function to compute the count of stones after `n` blinks with caching
function countnums_2(x::Int, n::Int, cache::Dict{Tuple{Int, Int}, Int})::Int
    # Check cache first
    if haskey(cache, (x, n))
        return cache[(x, n)]
    end

    # Base case
    if n == 0
        return 1
    end

    # Recursive case
    b = blink(x)
    if b isa Tuple
        result = countnums_2(b[1], n-1, cache) + countnums_2(b[2], n-1, cache)
    else
        result = countnums_2(b, n-1, cache)
    end

    # Store result in cache
    cache[(x, n)] = result
    return result
end

# Solve the problem for the given task data and number of blinks
function solve_2(data::Vector{Int}, n::Int)::Int
    # Initialize the cache
    cache = Dict{Tuple{Int, Int}, Int}()

    # Sum results for all stones
    return sum(x -> countnums_2(x, n, cache), data)
end

# Main function to handle program execution
function main()
    # Read input data
    taskdata = parse.(Int, split(read("./input.txt", String)))

    # Define the number of blinks
    n = 75

    # Compute the solution and display the result
    result = solve_2(taskdata, n)
    println("Number of stones after $n blinks: $result")
end

# Entry point for the script
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
