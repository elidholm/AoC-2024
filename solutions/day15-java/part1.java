import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;
import java.io.File;
import java.io.FileNotFoundException;


class Part1 {
    public static void main(String []args) {
        // Read input file
        List<String> input = readInput("input.txt");

        // Parse input into map and movement instructions
        List<List<Character>> warehouseMap = new ArrayList<>();
        String instructions = parseInput(input, warehouseMap);

        // Find the robot's starting position
        int[] robotPosition = findRobot(warehouseMap);

        // Execute movement instructions
        for (char move : instructions.toCharArray()) {
            robotPosition = executeMove(warehouseMap, robotPosition, move);
        }

        // Calculate the final GPS sum of all boxes
        long result = calculateGpsSum(warehouseMap);
        System.out.printf("Result: %s\n", result);
    }

    /**
     * Reads the input file and returns its contents as a list of strings.
     */
    private static List<String> readInput(String filename) {
        List<String> lines = new ArrayList<>();
        try (Scanner scanner = new Scanner(new File(filename))) {
            while (scanner.hasNextLine()) {
                lines.add(scanner.nextLine());
            }
        } catch (FileNotFoundException e) {
            System.err.println("Error: File not found!");
            e.printStackTrace();
        }
        return lines;
    }

    /**
     * Parses input data into the warehouse map and movement instructions.
     */
    private static String parseInput(List<String> input, List<List<Character>> warehouseMap) {
        StringBuilder instructions = new StringBuilder();
        boolean isInstructionPart = false;

        for (String line : input) {
            if (line.isBlank()) {
                isInstructionPart = true; // Switch to parsing instructions
                continue;
            }

            if (!isInstructionPart) {
                // Parse map line into a list of characters
                List<Character> row = new ArrayList<>();
                for (char c : line.toCharArray()) {
                    row.add(c);
                }
                warehouseMap.add(row);
            } else {
                // Append instruction characters
                instructions.append(line);
            }
        }
        return instructions.toString();
    }

    /**
     * Finds the position of the robot on the map.
     */
    private static int[] findRobot(List<List<Character>> map) {
        for (int i = 0; i < map.size(); i++) {
            for (int j = 0; j < map.get(i).size(); j++) {
                if (map.get(i).get(j) == '@') {
                    return new int[]{i, j};
                }
            }
        }
        return new int[]{-1, -1}; // Default position if not found
    }

    /**
     * Executes a single move of the robot and handles box-pushing logic.
     */
    private static int[] executeMove(List<List<Character>> map, int[] robot, char move) {
        // Determine direction vector for the given move
        int[] direction = new int[2];
        switch (move) {
            case '^': direction = new int[]{-1, 0}; break;
            case '>': direction = new int[]{0, 1}; break;
            case 'v': direction = new int[]{1, 0}; break;
            case '<': direction = new int[]{0, -1}; break;
        }

        mapSet(map, robot, '.'); // Clear robot's current position
        int[] nextPos = takeStep(robot, direction);

        if (mapGet(map, nextPos) == '.') {
            robot = nextPos;
        } else if (mapGet(map, nextPos) == 'O' && canPush(map, nextPos, direction)) {
            pushBox(map, nextPos, direction);
            robot = nextPos;
        }
        mapSet(map, robot, '@');

        return robot;
    }

    /**
     * Checks if a box can be pushed in the specified direction.
     */
    private static boolean canPush(List<List<Character>> map, int[] target, int[] dir) {
        // Base cases
        if (mapGet(map, target) == '#') { return false; }
        if (mapGet(map, target) == '.') { return true; }

        // Recursive case
        return canPush(map, takeStep(target, dir), dir);
    }

    /**
     * Pushes a box in the specified direction.
     */
    private static void pushBox(List<List<Character>> map, int[] curr, int[] dir) {
        int[] next = takeStep(curr, dir);

        if (mapGet(map, next) == '.') {
            // Free space, push ourselves
            mapSet(map, next, mapGet(map, curr));
            mapSet(map, curr, '.');
        } else {
            // Another box in front, try to push it
            pushBox(map, next, dir);
            // Pushed boxes in front of us, now we can push ourselves
            mapSet(map, next, mapGet(map, curr));
            mapSet(map, curr, '.');
        }
    }

    /**
     * Calculates the GPS sum of all boxes on the map.
     */
    private static long calculateGpsSum(List<List<Character>> map) {
        long sum = 0;
        for (int i = 0; i < map.size(); i++) {
            for (int j = 0; j < map.get(i).size(); j++) {
                if (map.get(i).get(j) == 'O') {
                    sum += 100L * i + j;
                }
            }
        }
        return sum;
    }

    /**
     * Returns the map value at the specified position.
     */
    private static char mapGet(List<List<Character>> map, int[] pos) {
        return map.get(pos[0]).get(pos[1]);
    }

    /**
     * Sets a character value at the specified position in the map.
     */
    private static void mapSet(List<List<Character>> map, int[] pos, char value) {
        map.get(pos[0]).set(pos[1], value);
    }

    /**
     * Takes a step in the specified direction.
     */
    private static int[] takeStep(int[] position, int[] direction) {
        return new int[]{position[0] + direction[0], position[1] + direction[1]};
    }
}