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
}

impl Hike {
    fn new(visited: Vec<(usize, usize)>, current: (usize, usize)) -> Self {
        Self { visited, current }
    }
}

fn main() {
    let input = include_str!("./input.txt");
    let result = part1(input, 71, 1024);
    dbg!(result);
}

fn generate_memory_space(size: usize, input: &str, n_bytes: usize) -> (Map, (usize, usize), (usize, usize)) {
    let map: Map = corrupt_memory(vec![vec!['.'; size]; size], input, n_bytes);

    let start = (0, 0);
    let end = (map.len() - 1, map[0].len() - 1);

    return (map, start, end);
}

fn corrupt_memory(mut memory_space: Map, input: &str, n_bytes: usize) -> Map {
    for (i, line) in input.lines().enumerate() {
        if i < n_bytes {
            let parts: Vec<&str> = line.split(',').map(str::trim).collect();
            let y = parts[0].parse::<usize>().unwrap();
            let x = parts[1].parse::<usize>().unwrap();
            memory_space[y][x] = '#';
        } else {
            break;
        }
    }

    return memory_space;
}

// Solves the maze using a priority queue and returns the lowest score
fn part1(input: &str, grid_size: usize, n_bytes: usize) -> usize {
    let (map, start, end): (Map, (usize, usize), (usize, usize)) = generate_memory_space(grid_size, input, n_bytes);

    let mut hikes = PriorityQueue::new();
    let mut costs_cache = HashMap::new();
    let mut shortest_path = usize::MAX;


    // Initialize the starting hike
    let initial_hike = Hike::new(vec![start], start);
    hikes.push(initial_hike.clone(), Reverse(initial_hike.visited.len()));
    costs_cache.insert(start, 0);

    while let Some((current_hike, _)) = hikes.pop() {
        let (y, x) = current_hike.current;

        // Check if we reached the end
        if current_hike.current == end {
            shortest_path = shortest_path.min(current_hike.visited.len());
            continue;
        }

        // Calculate possible moves
        let possible_moves = [
            (y as isize, x as isize + 1),  // Right
            (y as isize + 1, x as isize),  // Down
            (y as isize, x as isize - 1), // Left
            (y as isize - 1, x as isize), // Up
        ]
        .iter()
        .filter_map(|&(ny, nx)| {
            if ny >= 0 && nx >= 0  && (ny as usize) < map.len() && nx < map[ny as usize].len() as isize {
                let new_pos = (ny as usize, nx as usize);
                if map[new_pos.0][new_pos.1] != '#' && !current_hike.visited.contains(&new_pos) {
                    Some(new_pos)
                } else {
                    None
                }
            } else {
                None
            }
        })
        .collect::<Vec<(usize, usize)>>();

        // Process each possible move
        for next in possible_moves {
            let mut new_visited = current_hike.visited.clone();
            new_visited.push(next);

            if new_visited.len() >= shortest_path {
                continue;
            }

            if costs_cache.contains_key(&next) {
                if costs_cache.get(&next).unwrap() <= &new_visited.len() {
                    continue;
                }
            } else {
                costs_cache.insert(next, new_visited.len());
            }

            hikes.push(Hike::new(new_visited.clone(), next), Reverse(new_visited.len()));
        }
    }

    shortest_path - 1
}



#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = part1("5,4
4,2
4,5
3,0
2,1
6,3
2,4
1,5
0,6
3,3
2,6
5,1
1,2
5,5
2,5
6,5
1,4
0,4
6,4
1,1
6,1
1,0
0,5
1,6
2,0", 7, 12);
        assert_eq!(result, 22);
    }
}
