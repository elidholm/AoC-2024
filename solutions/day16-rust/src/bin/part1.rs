use std::collections::HashMap;
use priority_queue::PriorityQueue;
use std::cmp::Reverse;

// Represents the grid-based map of the maze
type Map = Vec<Vec<char>>;

// Represents a single hike attempt through the maze
#[derive(Debug, Clone, Eq, PartialEq, Hash)]
struct Hike {
    pub visited: Vec<(usize, usize)>,
    pub current: (usize, usize),
    pub direction: (isize, isize),
    pub cost: u32,
}

impl Hike {
    fn new(visited: Vec<(usize, usize)>, current: (usize, usize), direction: (isize, isize), cost: u32) -> Self {
        Self { visited, current, direction, cost }
    }
}

fn main() {
    let input = include_str!("./input.txt");
    let result = part1(input);
    dbg!(result);
}

// Parses the input string into the maze map, start, and end positions
fn parse_input(input: &str) -> (Map, (usize, usize), (usize, usize)) {
    let map: Map = input.lines().map(|line| line.chars().collect()).collect();
    let start = find_position(&map, 'S');
    let end = find_position(&map, 'E');
    (map, start, end)
}

// Finds the position of a specific character in the map
fn find_position(map: &Map, target: char) -> (usize, usize) {
    for (i, row) in map.iter().enumerate() {
        if let Some(j) = row.iter().position(|&c| c == target) {
            return (i, j);
        }
    }
    panic!("Character '{}' not found in the map", target);
}

// Solves the maze using a priority queue and returns the lowest score
fn part1(input: &str) -> u32 {
    let (map, start, end) = parse_input(input);

    let mut hikes = PriorityQueue::new();
    let mut costs_cache = HashMap::new();
    let mut cheapest_cost = u32::MAX;

    // Initialize the starting hike
    let initial_hike = Hike::new(vec![start], start, (0, 1), 0);
    hikes.push(initial_hike.clone(), Reverse(initial_hike.cost));
    costs_cache.insert(start, 0);

    while let Some((current_hike, _)) = hikes.pop() {
        let (y, x) = current_hike.current;

        // Check if we reached the end
        if current_hike.current == end {
            cheapest_cost = cheapest_cost.min(current_hike.cost);
            continue;
        }

        // Calculate possible moves
        let possible_moves = [
            ((y as isize, x as isize + 1), (0, 1)),  // Right
            ((y as isize + 1, x as isize), (1, 0)),  // Down
            ((y as isize, x as isize - 1), (0, -1)), // Left
            ((y as isize - 1, x as isize), (-1, 0)), // Up
        ]
        .iter()
        .filter_map(|&((ny, nx), direction)| {
            if ny >= 0 && nx >= 0 {
                let new_pos = (ny as usize, nx as usize);
                if map[new_pos.0][new_pos.1] != '#' && !current_hike.visited.contains(&new_pos) {
                    Some((new_pos, direction))
                } else {
                    None
                }
            } else {
                None
            }
        })
        .collect::<Vec<_>>();

        // Process each possible move
        for (next, direction) in possible_moves {
            let mut new_visited = current_hike.visited.clone();
            let mut new_cost = current_hike.cost + 1;
            if direction != current_hike.direction {
                new_cost += 1000;
            }

            if new_cost >= cheapest_cost {
                continue;
            }

            if let Some(&existing_cost) = costs_cache.get(&next) {
                if existing_cost <= new_cost {
                    continue;
                }
            }

            costs_cache.insert(next, new_cost);
            new_visited.push(next);
            hikes.push(
                Hike::new(new_visited, next, direction, new_cost),
                Reverse(new_cost),
            );
        }
    }

    cheapest_cost
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_example() {
        let input = "################
#...#...#...#..E#
#.#.#.#.#.#.#.#.#
#.#.#.#...#...#.#
#.#.#.#.###.#.#.#
#...#.#.#.....#.#
#.#.#.#.#.#####.#
#.#...#.#.#.....#
#.#.#####.#.###.#
#.#.#.......#...#
#.#.###.#####.###
#.#.#...#.....#.#
#.#.#.#####.###.#
#.#.#.........#.#
#.#.#.#########.#
#S#.............#
#################";
        assert_eq!(part1(input), 11048);
    }
}

