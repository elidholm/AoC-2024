package main

import (
	"bufio"
	"fmt"
	"os"
	"strconv"
	"strings"
)

// HQMap represents the map dimensions.
type HQMap struct {
	xSize int
	ySize int
}

// Robot represents a robot's position and velocity.
type Robot struct {
	vX int
	vY int
	x  int
	y  int
}

func main() {
	// Read input from file.
	input := readFile("./input.txt")

	// Parse the input data.
	parsedData := parseInput(input)

	// Initialize HQ map dimensions.
	hqMap := HQMap{xSize: 101, ySize: 103}

	// Solve the problem and print the result.
	result := solve(parsedData, hqMap, hqMap.xSize*hqMap.ySize)
	fmt.Printf("Result: %d\n", result)
}

// solve simulates the robots' movements for a given number of seconds and calculates the safety factor.
func solve(inputData []string, hqMap HQMap, seconds int) int {
	var robots []Robot
	for _, line := range inputData {
		parts := strings.Split(line, " ")
		pos := strings.Split(parts[0], ",")
		vel := strings.Split(parts[1], ",")

		x, _ := strconv.Atoi(pos[0])
		y, _ := strconv.Atoi(pos[1])
		vX, _ := strconv.Atoi(vel[0])
		vY, _ := strconv.Atoi(vel[1])

		robots = append(robots, Robot{x: x, y: y, vX: vX, vY: vY})
	}

	for i := 0; i < seconds; i++ {
		clockTick(robots, hqMap)
        if checkAlignment(robots, hqMap) {
			return i + 1
		}
	}
    panic("No Solution found!")
}

// clockTick updates the positions of all robots based on their velocities.
func clockTick(robots []Robot, hqMap HQMap) {
	for i := range robots {
		moveRobot(&robots[i], hqMap)
	}
}

// moveRobot updates a single robot's position, wrapping around map edges.
func moveRobot(robot *Robot, hqMap HQMap) {
	robot.x = (robot.x + robot.vX + hqMap.xSize) % hqMap.xSize
	robot.y = (robot.y + robot.vY + hqMap.ySize) % hqMap.ySize
}

func checkAlignment(Robots []Robot, hqMap HQMap) bool {
	var grid [][]int
	grid = make([][]int, hqMap.ySize)
	for y := 0; y < hqMap.ySize; y++ {
		grid[y] = make([]int, hqMap.xSize)
	}
	for _, robot := range Robots {
		grid[robot.y][robot.x]++
	}
	count := 0
	for y := 0; y < hqMap.ySize; y++ {
		count = 0
		for x := 0; x < hqMap.xSize; x++ {
			if grid[y][x] == 1 {
				count++
			}
			if count > 10 {
				return true
			}
			if grid[y][x] == 0 {
				count = 0
			}
		}
	}

	return false
}


// parseInput processes input lines to remove unwanted prefixes.
func parseInput(input []string) []string {
	replacer := strings.NewReplacer("p=", "", "v=", "")
	var parsedLines []string
	for _, line := range input {
		parsedLines = append(parsedLines, replacer.Replace(line))
	}
	return parsedLines
}

// readFile reads lines from a file into a string slice.
func readFile(fileName string) []string {
	file, err := os.Open(fileName)
	check(err)
	defer file.Close()

	var lines []string
	scanner := bufio.NewScanner(file)
	for scanner.Scan() {
		lines = append(lines, scanner.Text())
	}

	return lines
}

// check handles errors by terminating the program.
func check(err error) {
	if err != nil {
		fmt.Printf("Error: %v\n", err)
		os.Exit(1)
	}
}

