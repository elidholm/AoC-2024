use std::collections::{ HashSet, HashMap };
use priority_queue::PriorityQueue;
use std::cmp::Reverse;

fn main() {
    let input = include_str!("./input.txt");
    let output = part2(input);
    dbg!(output);
}

type Map = Vec<Vec<char>>;

#[derive(Debug, Clone, Eq, PartialEq, Hash)]
struct Hike {
    pub visited: Vec<(usize, usize)>,
    pub current: (usize, usize),
    pub direction: (isize, isize),
    pub cost: i32,
}


impl Hike {
    fn new(visited: Vec<(usize, usize)>, current: (usize, usize), direction: (isize, isize), cost: i32) -> Self {
        Self { visited, current, direction, cost }
    }
}

fn parse_input(input: &str) -> (Map, (usize, usize), (usize, usize)) {
    let map: Map = input.lines().map(|line| line.chars().collect()).collect();
    let start: (usize, usize) = _find_start(&map);
    let end: (usize, usize) = _find_end(&map);

    return (map, start, end);
}

fn _find_start(map: &Map) -> (usize, usize) {
    let n_rows: usize = map.len();
    return (n_rows - 2, map[n_rows - 2].iter().position(|x| *x == 'S').unwrap());
}

fn _find_end(map: &Map) -> (usize, usize) {
    return (1, map[1].iter().position(|x| *x == 'E').unwrap());
}

fn print_hike(map: &Map, solution: &HashSet<(usize, usize)>) {
    let mut i: usize = 0;
    for line in map {
        let mut j: usize = 0;
        for c in line {
            if solution.contains(&(i, j)) {
                print!("O");
            } else {
                print!("{}", c);
            }
            j += 1;
        }
        i += 1;
        println!();
    }
}

fn hashset(data: &Vec<(usize, usize)>) -> HashSet<(usize, usize)> {
    HashSet::from_iter(data.iter().cloned())
}

fn part2(input: &str) -> usize {
    let (map, start, end): (Map, (usize, usize), (usize, usize)) = parse_input(input);

    let mut hikes = PriorityQueue::new();
    let mut deez: Vec<(usize, usize)> = Vec::new();

    let mut nuts: HashMap<((usize, usize), (isize, isize)), i32> = HashMap::new();
    deez.push(start);
    nuts.insert((start, (0, 1)), 0);
    let mut cheapest_hike: Hike = Hike::new(deez, start, (0, 1), 0);

    hikes.push(cheapest_hike.clone(), Reverse(cheapest_hike.clone().cost));

    let mut n_hikes = 0;

    let mut ligma: HashSet<(usize, usize)> = HashSet::new();

    while hikes.len() > 0 {
        let (hike, _): (Hike, Reverse<i32>) = hikes.pop().unwrap();
        let (y, x): (usize, usize) = hike.current;

        if hike.current == end {
            if hike.cost < cheapest_hike.cost || cheapest_hike.cost <= 0 {
                cheapest_hike = hike;
                println!("Finished hike nr: {},\tCheapest: {},\tActive hikes: {},\tSquares found: {}", n_hikes, cheapest_hike.cost, hikes.len(), nuts.len());
                ligma = hashset(&cheapest_hike.visited);
            } else if hike.cost == cheapest_hike.cost {
                println!("Finished hike nr: {},\tCheapest: {},\tActive hikes: {},\tSquares found: {}", n_hikes, cheapest_hike.cost, hikes.len(), nuts.len());
                ligma.extend(&hashset(&hike.visited));
            }
            continue;
        }

        let x_temp: isize = x as isize;
        let y_temp: isize = y as isize;

        let possible_steps = vec![((y_temp, x_temp + 1), (0, 1)), ((y_temp + 1, x_temp), (1, 0)), ((y_temp, x_temp - 1), (0, -1)), ((y_temp - 1, x_temp), (-1, 0))]
                                    .into_iter()
                                    .filter(|((y, x), _)| *y >= 0 &&
                                                        *x >= 0 &&
                                                        !hike.visited.contains(&(*y as usize, *x as usize)) &&
                                                        map[*y as usize][*x as usize] != '#')
                                    .map(|((y, x), (a, b))| ((y as usize, x as usize), (a, b)))
                                    .collect::<Vec<((usize, usize),(isize, isize))>>();

        for (next, dir) in possible_steps {
            let mut deez: Vec<(usize, usize)> = hike.visited.clone();
            let mut new_cost: i32 = hike.cost + 1;
            if dir != hike.direction {
                new_cost += 1000;
            }
            if new_cost > cheapest_hike.cost &&  cheapest_hike.cost != 0 {
                continue;
            }

            deez.push(next);
            if nuts.contains_key(&(next, dir)) {
                if nuts.get(&(next, dir)).unwrap() < &new_cost {
                    continue;
                }
            } else {
                nuts.insert((next, dir), new_cost);
            }

            hikes.push(Hike::new(deez, next, dir, new_cost), Reverse(new_cost));
        }
        if n_hikes % 100000 == 0 {
            println!("Finished hike nr: {},\tCheapest: {},\tActive hikes: {},\tSquares found: {}", n_hikes, cheapest_hike.cost, hikes.len(), nuts.len());
        }

        n_hikes+=1;
    }

    println!("{:?}", cheapest_hike.visited);

    print_hike(&map, &ligma);
    ligma.len()
}



#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = part2("#################
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
#################");
        assert_eq!(result, 64);
    }
}
