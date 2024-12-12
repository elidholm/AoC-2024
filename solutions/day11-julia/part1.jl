# Utility function to calculate the number of digits in an integer
function number_of_digits(x::Int)
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

# Recursive function to compute the count of stones after `n` blinks
function countnums(x::Int, n::Int)
    if n == 0
        return 1
    else
        b = blink(x)
        # Handle cases where blink(x) returns a tuple (from `divrem`) or a single number.
        if b isa Tuple
            return countnums(b[1], n-1) + countnums(b[2], n-1)
        else
            return countnums(b, n-1)
        end
    end
end

# Solve the problem for the given task data and number of blinks
function solve_1(data::Vector{Int}, n::Int)::Int
    return sum(x -> countnums(x, n), data)
end

# Main function to handle program execution
function main()
    # Read input data
    taskdata = parse.(Int, split(read("./input.txt", String)))

    # Define the number of blinks
    n = 25

    # Compute the solution and display the result
    result = solve_1(taskdata, n)
    println("Number of stones after $n blinks: $result")
end

# Entry point for the script
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end
