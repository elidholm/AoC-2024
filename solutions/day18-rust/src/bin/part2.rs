use core::panic;
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
    let result = part2(input, 71, 1024, 3450);
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

fn part2(input: &str, grid_size: usize, n_bytes_1: usize, n_bytes_2: usize) -> &str {
    for doink in n_bytes_1..n_bytes_2 {
        let (map, start, end): (Map, (usize, usize), (usize, usize)) = generate_memory_space(grid_size, input, doink);
        println!("{}", doink);

        let mut hikes = PriorityQueue::new();

        // Initialize the starting hike
        let initial_hike = Hike::new(vec![start], start);
        hikes.push(initial_hike.clone(), Reverse(initial_hike.visited.len()));

        let mut found = false;

        while let Some((current_hike, _)) = hikes.pop() {
            let (y, x) = current_hike.current;

            // Check if we reached the end
            if current_hike.current == end {
                found = true;
                break;
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

                hikes.push(Hike::new(new_visited.clone(), next), Reverse(new_visited.len()));
            }
        }
        if !found {
            return input.lines().nth(doink - 1).unwrap();
        }
    }
    panic!("No solution");
}



#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = part2("5,4
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
2,0", 7, 12, 25);
        assert_eq!(result, "6,1");
    }
}
