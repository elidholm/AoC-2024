// Import the necessary module for reading files
import { readFileSync } from "fs";

// Read and parse input data
const inputSections = readFileSync("./input.txt", "utf-8")
  .trim()
  .split("\n\n")
  .map(section => section.split("\n"));

// Define the supported gate operations
const gateOperations = {
  AND: (left, right) => left & right,
  OR: (left, right) => left | right,
  XOR: (left, right) => left ^ right,
};

// Initialize global variables to track wire values and bounds
const wireValues = {}; // Stores the calculated values for each wire
const zWireValues = {}; // Stores values for wires starting with 'z'
const parsedInstructions = []; // Instructions for processing gates
let minBitIndex = Infinity; // Minimum bit index (e.g., x00 -> 0)
let maxBitIndex = -Infinity; // Maximum bit index (e.g., z45 -> 45)
let unprocessedInstructions = []; // Instructions to be processed
let swappedOutputWires = []; // Tracks wires involved in invalid connections

// Parse initial wire values from the first input section
inputSections[0].forEach(line => {
  const [wire, value] = line.split(": ");
  wireValues[wire] = Number(value);

  // Update the minimum and maximum bit indices
  const bitIndex = Number(wire.slice(1));
  minBitIndex = Math.min(minBitIndex, bitIndex);
  maxBitIndex = Math.max(maxBitIndex, bitIndex + 1);
});

// Parse gate instructions from the second input section
inputSections[1].forEach(line => {
  const [leftWire, operation, rightWire, , outputWire] = line.split(" ");
  const instruction = { operation, leftWire, rightWire, outputWire };
  parsedInstructions.push(instruction);
  unprocessedInstructions.push(instruction);
});

// Process instructions until all are resolved
while (unprocessedInstructions.length > 0) {
  // Extract the first instruction for processing
  const currentInstruction = unprocessedInstructions.shift();
  const { operation, leftWire, rightWire, outputWire } = currentInstruction;

  // If either input wire is undefined, defer the instruction
  if (isNaN(wireValues[leftWire]) || isNaN(wireValues[rightWire])) {
    unprocessedInstructions.push(currentInstruction);
    continue;
  }

  // Calculate the output value and store it
  wireValues[outputWire] = gateOperations[operation](
    wireValues[leftWire],
    wireValues[rightWire]
  );

  // If the output wire starts with 'z', track its value separately
  if (outputWire.startsWith("z")) {
    zWireValues[outputWire] = wireValues[outputWire];
  }

  // Identify invalid connections based on manual testing and observed rules
  const isInvalidConnection = (
    (outputWire.startsWith("z") && operation !== "XOR" && Number(outputWire.slice(1)) < maxBitIndex) ||
    (!outputWire.startsWith("z") && !"xy".includes(leftWire[0]) && !"xy".includes(rightWire[0]) && operation === "XOR") ||
    ("xy".includes(leftWire[0]) && Number(leftWire.slice(1)) > minBitIndex &&
      "xy".includes(rightWire[0]) && Number(rightWire.slice(1)) > minBitIndex &&
      operation === "XOR" &&
      !parsedInstructions.some(next => next.operation === "XOR" && (next.leftWire === outputWire || next.rightWire === outputWire))) ||
    ("xy".includes(leftWire[0]) && Number(leftWire.slice(1)) > minBitIndex &&
      "xy".includes(rightWire[0]) && Number(rightWire.slice(1)) > minBitIndex &&
      operation === "AND" &&
      !parsedInstructions.some(next => next.operation === "OR" && (next.leftWire === outputWire || next.rightWire === outputWire)))
  );

  if (isInvalidConnection) {
    swappedOutputWires.push(outputWire);
  }
}

// Sort and output the invalid connections
swappedOutputWires.sort();
console.log(`answer part 2: ${swappedOutputWires.join(",")}`);

