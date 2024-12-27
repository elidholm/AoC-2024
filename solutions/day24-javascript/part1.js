import { readFileSync } from "fs";

// Read and parse input
const input = readFileSync("./input.txt", "utf-8")
  .trim()
  .split("\n\n")
  .map((section) => section.split("\n"));

// Define gate operations
const gateOperations = {
  AND: (left, right) => left & right,
  OR: (left, right) => left | right,
  XOR: (left, right) => left ^ right,
};

// Variables to hold data
const wireValues = {};
const zWireValues = {};
let minBitIndex = Infinity;
let maxBitIndex = -Infinity;

// Parse initial wire values
const initialWireValues = input[0];
initialWireValues.forEach((line) => {
  const [wire, value] = line.split(": ");
  wireValues[wire] = Number(value);

  const bitIndex = Number(wire.substring(1));
  minBitIndex = Math.min(minBitIndex, bitIndex);
  maxBitIndex = Math.max(maxBitIndex, bitIndex + 1);
});

// Parse gate instructions
const gateInstructions = input[1].map((line) => {
  const [leftInput, operation, rightInput, , outputWire] = line.split(" ");
  return { leftInput, operation, rightInput, outputWire };
});

// Process gate instructions until all are resolved
const pendingInstructions = [...gateInstructions];

while (pendingInstructions.length > 0) {
  const instruction = pendingInstructions.shift();
  const { leftInput, operation, rightInput, outputWire } = instruction;

  // Check if inputs have valid values
  if (isNaN(wireValues[leftInput]) || isNaN(wireValues[rightInput])) {
    pendingInstructions.push(instruction); // Re-add unresolved instruction to the end
  } else {
    // Calculate output value
    wireValues[outputWire] = gateOperations[operation](
      wireValues[leftInput],
      wireValues[rightInput]
    );

    // Save z-wire values separately
    if (outputWire.startsWith("z")) {
      zWireValues[outputWire] = wireValues[outputWire];
    }
  }
}

// Convert z-wire values to a binary string and calculate the final result
const zWireBinaryString = Object.keys(zWireValues)
  .sort()
  .reverse()
  .map((key) => zWireValues[key])
  .join("");

const finalResult = parseInt(zWireBinaryString, 2);

// Output the result
console.log(`Result part 1: ${finalResult}`);

