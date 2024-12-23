#!/usr/bin/env groovy

// Import required classes for file operations
import java.nio.file.*

/**
 * Mixes a value into the secret number using bitwise XOR.
 * @param secretNumber The current secret number.
 * @param value The value to mix into the secret number.
 * @return The new secret number after mixing.
 */
def mix(int secretNumber, int value) {
    return secretNumber ^ value // Perform bitwise XOR
}

/**
 * Prunes the secret number by taking it modulo 16777216.
 * Ensures a positive result by adding 16777216 before taking modulo.
 * @param secretNumber The current secret number.
 * @return The new secret number after pruning.
 */
def prune(int secretNumber) {
    return ((secretNumber % 16777216) + 16777216) % 16777216
}

/**
 * Generates the next secret number in the sequence.
 * This involves three steps: multiplying, mixing, and pruning.
 * @param secretNumber The current secret number.
 * @return The next secret number.
 */
def generate(int secretNumber) {
    // Step 1: Multiply by 64, mix, and prune
    def step1 = prune(mix(secretNumber * 64, secretNumber))

    // Step 2: Divide by 32, mix, and prune
    def step2 = prune(mix(step1.intdiv(32), step1))

    // Step 3: Multiply by 2048, mix, and prune
    def step3 = prune(mix(step2 * 2048, step2))

    return step3
}

// Define the input filename (assumes the file is in the same directory as the script)
def fileName = "input.txt"

try {
    // Read the file and convert each line to an integer
    List<Integer> secretNumbers = Files.readAllLines(Paths.get(fileName))
                                       .collect { it as Integer } // Convert each line to an Integer

    // Initialize the result to 0 (using BigInteger to handle large sums)
    def result = 0G

    // Process each buyer's initial secret number
    secretNumbers.each { initialSecret ->
        def secretNumber = initialSecret

        // Simulate 2000 iterations to generate the 2000th secret number
        (1..2000).each {
            secretNumber = generate(secretNumber)
        }

        // Add the 2000th secret number to the total result
        result += secretNumber
    }

    // Output the final result
    println("Result: ${result}")

} catch (IOException e) {
    // Handle file read errors gracefully
    println("Error reading the file: ${e.message}")
} catch (NumberFormatException e) {
    // Handle errors when converting lines to integers
    println("Error converting a line to an integer: ${e.message}")
}

