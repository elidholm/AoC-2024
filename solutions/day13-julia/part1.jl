# Function to solve equations
function solve_equations(input::Vector{Int64}; scale::Int64=0)::Int64
    result = 0
    for i in 1:6:length(input)
        # Extract values for this chunk
        ax, ay, bx, by, x, y = input[i:i+5]

        # Construct the matrices
        A = Rational.([ax bx; ay by])
        S = Rational.([x + scale; y + scale])

        # Solve the system of equations
        a, b = A \ S

        # Check if a and b are close to integers
            if isinteger(a) && isinteger(b)
            result += 3Int(a) + Int(b)
        end
    end
    return result
end

# Main function to read input and compute the solution
function main()
    # Read input data from the file
    input_content = read("./input.txt", String)
    matches = eachmatch(r"\d+", input_content)
    task_data = parse.(Int, [m.match for m in matches])

    # Solve the problem
    result = solve_equations(task_data)
    println("Result: $result")
end

# Run the main function if this script is executed directly
if abspath(PROGRAM_FILE) == @__FILE__
    main()
end

