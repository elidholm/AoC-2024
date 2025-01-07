#!/usr/bin/env python3
"""
Script to solve Advent of Code day 8 problem part 1.
Usage: python part1.py [--debug]
"""

import argparse
import logging
from typing import Dict, List, Set, Tuple

from rich.logging import RichHandler

# Configure logging
_log = logging.getLogger(__name__)
FORMAT = "%(message)s"
logging.basicConfig(level="NOTSET", format=FORMAT, datefmt="[%X]", handlers=[RichHandler()])


def is_within_bounds(point: Tuple[int, int], grid: List[str]) -> bool:
    """Check if a point is within the grid boundaries."""
    row, col = point
    return 0 <= row < len(grid) and 0 <= col < len(grid[row])


def extract_antennas(grid: List[str]) -> Dict[str, List[Tuple[int, int]]]:
    """Extract all antenna positions categorized by their labels."""
    _log.debug("Extracting antennas from the grid")
    antenna_positions: Dict[str, List[Tuple[int, int]]] = {}
    for row_idx, row in enumerate(grid):
        for col_idx, char in enumerate(row):
            if char != ".":
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
                antinode = (b[0] - dx, b[1] - dy)
                if is_within_bounds(antinode, grid):
                    antinodes.add(antinode)
    _log.debug("Calculated antinodes: %s", antinodes)
    return antinodes


def part_1(grid: List[str]) -> int:
    """Solve part 1 by counting the number of antinodes that fall within the grid.."""
    _log.info("STARTED calculation of valid antinodes for part 1")
    antennas = extract_antennas(grid)
    antinodes = calculate_antinodes(antennas, grid)
    result = sum(1 for antinode in antinodes if is_within_bounds(antinode, grid))
    _log.info("FINISHED calculation of valid antinodes for part 1")
    return result


def parse_input(file_name: str) -> List[str]:
    """Parse the input and return a grid as a list of strings."""
    _log.info("STARTED parsing input from %s", file_name)
    try:
        with open(file_name, mode="r", encoding="utf-8") as f:
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
    parser = argparse.ArgumentParser(description="Solve Advent of Code day 8 problem part 1.")
    parser.add_argument("--debug", action="store_true", help="Enable extra verbose debug logging")
    args = parser.parse_args()

    # Set logging level based on --debug flag
    log_level = logging.DEBUG if args.debug else logging.INFO
    logging.getLogger().setLevel(log_level)

    _log.debug("Script started with debug mode: %s", args.debug)

    try:
        input_data = parse_input("input.txt")
        result = part_1(input_data)
        _log.info("Result: %s", result)
    except Exception as e:
        _log.error("An error occured: %s", e)

    _log.debug("Script finished")


if __name__ == "__main__":
    main()
