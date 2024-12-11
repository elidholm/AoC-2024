#!/usr/bin/env python3
"""
Script to solve Advent of Code day 6 problem part 2.
Usage: python part2.py [--debug]
"""

import argparse
import logging
from typing import List
from rich.logging import RichHandler

# Configure logging
_log = logging.getLogger(__name__)
FORMAT = "%(message)s"
logging.basicConfig(
    level="NOTSET", format=FORMAT, datefmt="[%X]", handlers=[RichHandler()]
)


class Equation:
    """Represents a mathematical equation with a target value and operands."""

    def __init__(self, target_value: int, operands: List[int]):
        self.target_value = target_value
        self.operands = operands

    def is_solvable(self) -> bool:
        """Determine if the equation is solvable."""
        _log.debug("Checking %s", self)
        return self._is_solvable(self.operands)

    def _is_solvable(self, operands: List[int]) -> bool:
        if operands[0] > self.target_value:
            return False
        if len(operands) == 1:
            return operands[0] == self.target_value
        if self._is_solvable([operands[0] + operands[1]] + operands[2:]):
            return True
        if self._is_solvable([operands[0] * operands[1]] + operands[2:]):
            return True
        if self._is_solvable([int(str(operands[0]) + str(operands[1]))] + operands[2:]):
            return True
        return False

    def __str__(self) -> str:
        """Return a nicely formatted string representation of the equation."""
        operands_str = " ".join(map(str, self.operands))
        return f"Target: {self.target_value}, Operands: [{operands_str}]"

    def __repr__(self) -> str:
        """Provide an unambiguous representation for debugging."""
        return f"Equation(target_value={self.target_value}, operands={self.operands})"


def part_2(equations: List[Equation]) -> int:
    """Solve part 2 by summing target values of solvable equations."""
    _log.info("STARTED solving equations for part 2")
    result = 0
    for eq in equations:
        if eq.is_solvable():
            _log.debug("Equation %s is solvable", eq)
            result += eq.target_value
        else:
            _log.debug("Equation %s is NOT solvable", eq)
    _log.info("FINISHED solving equations for part 2")
    return result


def parse_input(file_name: str) -> List[Equation]:
    """Parse the input and return a list of equations."""
    _log.info("STARTED parsing input from %s", file_name)
    equations = []
    try:
        with open(file_name, "r") as f:
            for line in f:
                left, right = line.strip().split(":")
                target_value = int(left)
                operands = [int(x) for x in right.split()]
                equations.append(Equation(target_value, operands))
    except FileNotFoundError:
        _log.error("File %s not found", file_name)
        raise
    except ValueError as e:
        _log.error("Error parsing file %s: %s", file_name, e)
        raise
    _log.info("FINISHED parsing input")
    return equations


def main() -> None:
    """Main entry point of script."""
    parser = argparse.ArgumentParser(description="Solve equations from input file.")
    parser.add_argument("--debug", action="store_true", help="Enable extra verbose debug logging")
    args = parser.parse_args()

    # Set logging level based on --debug flag
    log_level = logging.DEBUG if args.debug else logging.INFO
    logging.getLogger().setLevel(log_level)

    _log.debug("Script started with debug mode: %s", args.debug)

    try:
        equations = parse_input("input.txt")
        result = part_2(equations)
        _log.info("Result: %s", result)
    except Exception as e:
        _log.error("An error occured: %s", e)

    _log.debug("Script finished")


if __name__ == "__main__":
    main()
