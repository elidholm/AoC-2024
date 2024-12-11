#!/usr/bin/env python3
"""
Script to solve Advent of Code day 7 problem part 2.
Usage: python part1.py [--debug]
"""

import argparse
import logging
from typing import List, Tuple, Dict, Set
from rich.logging import RichHandler

# Configure logging
_log = logging.getLogger(__name__)
FORMAT = "%(message)s"
logging.basicConfig(
    level="NOTSET", format=FORMAT, datefmt="[%X]", handlers=[RichHandler()]
)


def is_within_bounds(point: Tuple[int, int], grid: List[str]) -> bool:
    """Check if a point is within the grid boundaries."""
    row, col = point
    return 0 <= row < len(grid) and 0 <= col < len(grid[row])


def extract_antennas(grid: List[str]) -> Dict[str, List[Tuple[int, int]]]:
    """Extract all antenna positions categorized by their labels."""
    _log.debug("Extracting antennas from the grid")
    antenna_positions = {}
    for row_idx, row in enumerate(grid):
        for col_idx, char in enumerate(row):
            if char != '.':
                antenna_positions.setdefault(char, []).append((row_idx, col_idx))
    _log.debug("Antennas extracted: %s", antenna_positions)
    return antenna_positions


def calculate_antinodes(antennas: Dict[str, List[Tuple[int, int]]], grid: List[str]) -> Set[Tuple[int, int]]:
    """Calculate all potential antinode positions based on antenna positions."""
    _log.debug("Calculating antinodes from antennas")
    antinodes = set()
    for label, positions in antennas.items():
        _log.debug("Processing antenna '%s' with positions: %s", label, positions)
        for a in positions:
            for b in positions:
                if a == b:
                    continue
                dx, dy = a[0] - b[0], a[1] - b[1]
                antinode = (b[0], b[1])
                while is_within_bounds(antinode, grid):
                    antinodes.add(antinode)
                    antinode = (antinode[0] - dx, antinode[1] - dy)
    _log.debug("Calculated antinodes: %s", antinodes)
    return antinodes


def part_1(grid: List[str]) -> int:
    """Solve part 2 by counting the number of antinodes that fall within the grid."""
    _log.info("STARTED calculation of valid antinodes for part 2")
    antennas = extract_antennas(grid)
    antinodes = calculate_antinodes(antennas, grid)
    result = len(antinodes)
    _log.info("FINISHED calculation of valid antinodes for part 2")
    return result


def parse_input(file_name: str) -> List[str]:
    """Parse the input and return a grid as a list of strings."""
    _log.info("STARTED parsing input from %s", file_name)
    try:
        with open(file_name, "r") as f:
            grid = [line.strip() for line in f]
            _log.info("FINISHED parsing input")
            return grid
    except FileNotFoundError:
        _log.error("File %s not found", file_name)
        raise
    except Exception as e:
        _log.error("Error parsing file %s: %s", file_name, e)
        raise


def main() -> None:
    """Main entry point for the script."""
    parser = argparse.ArgumentParser(description="Solve Advent of Code day 7 problem part 2.")
    parser.add_argument("--debug", action="store_true", help="Enable extra verbose debug logging")
    args = parser.parse_args()

    # Set logging level based on --debug flag
    log_level = logging.DEBUG if args.debug else logging.INFO
    logging.getLogger().setLevel(log_level)

    _log.debug("Script started with debug mode: %s", args.debug)

    try:
        input = parse_input("input.txt")
        result = part_1(input)
        _log.info("Result: %s", result)
    except Exception as e:
        _log.error("An error occured: %s", e)

    _log.debug("Script finished")


if __name__ == "__main__":
    main()
