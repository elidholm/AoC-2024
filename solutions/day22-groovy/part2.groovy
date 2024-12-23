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


/**
 * Generates a sequence of price differences mapped to their respective last prices.
 *
 * @param seed The initial seed value for generating the sequence.
 * @return A map where the keys are lists of the last four price differences, and the values are the corresponding prices.
 */
def generateSequences(int seed) {
    // Initialize the result map
    Map<List<Integer>, Integer> result = [:]

    // Initialize variables
    int previousSeed = seed
    int previousPrice = seed % 10
    List<Integer> collector = []

    // Iterate 2000 times to generate the sequence
    (1..2000).each {
        int nextSeed = generate(previousSeed) // Generate the next seed
        int price = nextSeed % 10            // Calculate the price
        int difference = price - previousPrice // Calculate the price difference

        collector.add(difference) // Collect the price difference

        // Once the collector has 4 elements, process it
        if (collector.size() == 4) {
            result.putIfAbsent(new ArrayList<>(collector), price) // Map the collector to the price
            collector.remove(0) // Remove the oldest element to maintain size
        }

        // Update for the next iteration
        previousPrice = price
        previousSeed = nextSeed
    }

    return result
}


// Define the input filename (assumes the file is in the same directory as the script)
def fileName = "input.txt"

try {
    // Read the file and convert each line to an integer
    List<Integer> secretNumbers = Files.readAllLines(Paths.get(fileName))
                                       .collect { it as Integer } // Convert each line to an Integer

    summingMap = [:]

    // Process each buyer's initial secret number
    secretNumbers.each { initialSecret ->
        generateSequences(initialSecret).each{ key, value ->
            summingMap.compute(key) { _, v -> v == null ? value : v + value }
        }
    }
    def result = summingMap.values().max()
    // Output the final result
    println("Result: ${result}")

} catch (IOException e) {
    // Handle file read errors gracefully
    println("Error reading the file: ${e.message}")
} catch (NumberFormatException e) {
    // Handle errors when converting lines to integers
    println("Error converting a line to an integer: ${e.message}")
}

