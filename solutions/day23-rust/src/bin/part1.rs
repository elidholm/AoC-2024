use std::collections::{HashMap, HashSet};

fn main() {
    // Read the input network map from a file
    let input = include_str!("./input.txt");

    // Calculate the number of qualifying triplets
    let result = count_triplets_with_t_prefix(input);

    // Print the result for debugging
    dbg!(result);
}

/// Represents the graph as a mapping of nodes to their connections.
type NetworkGraph = HashMap<String, HashSet<String>>;

/// Parses the input string into a graph representation.
///
/// # Arguments
/// - `input`: A string containing the network map.
///
/// # Returns
/// A `NetworkGraph` mapping nodes to their connected nodes.
fn parse_input(input: &str) -> NetworkGraph {
    let mut graph: NetworkGraph = HashMap::new();

    // Process each line to build the graph
    for line in input.lines() {
        let mut parts = line.split('-');
        let node_a = parts.next().unwrap().to_string();
        let node_b = parts.next().unwrap().to_string();

        graph.entry(node_a.clone())
            .or_insert_with(HashSet::new)
            .insert(node_b.clone());
        graph.entry(node_b)
            .or_insert_with(HashSet::new)
            .insert(node_a);
    }

    graph
}

/// Counts the number of triplets (three interconnected computers) in the graph
/// where at least one computer's name starts with the letter 't'.
///
/// # Arguments
/// - `input`: A string containing the network map.
///
/// # Returns
/// The count of qualifying triplets.
fn count_triplets_with_t_prefix(input: &str) -> usize {
    let graph = parse_input(input);

    // Holds all unique triplets
    let mut triplets: HashSet<(String, String, String)> = HashSet::new();

    // Iterate over all nodes and their connections
    for (node, connections) in &graph {
        // Skip nodes that don't start with 't'
        if !node.starts_with('t') {
            continue;
        }

        // Look for triplets by examining second-level connections
        for neighbor in connections {
            if let Some(neighbor_connections) = graph.get(neighbor) {
                for second_neighbor in neighbor_connections {
                    if graph.get(node).unwrap().contains(second_neighbor) {
                        let mut triplet = vec![
                            node.clone(),
                            neighbor.clone(),
                            second_neighbor.clone(),
                        ];

                        // Sort triplet for uniqueness and insert it
                        triplet.sort();
                        triplets.insert((
                            triplet[0].clone(),
                            triplet[1].clone(),
                            triplet[2].clone(),
                        ));
                    }
                }
            }
        }
    }

    triplets.len()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_count_triplets_with_t_prefix() {
        let input = "kh-tc
qp-kh
de-cg
ka-co
yn-aq
qp-ub
cg-tb
vc-aq
tb-ka
wh-tc
yn-cg
kh-ub
ta-co
de-co
tc-td
tb-wq
wh-td
ta-ka
td-qp
aq-cg
wq-ub
ub-vc
de-ta
wq-aq
wq-vc
wh-yn
ka-de
kh-ta
co-tc
wh-qp
tb-vc
td-yn";

        let result = count_triplets_with_t_prefix(input);
        assert_eq!(result, 7);
    }
}

