use std::collections::{HashMap, HashSet};

fn main() {
    // Read the input network map from a file
    let input = include_str!("./input.txt");

    // Calculate the number of qualifying triplets
    let result = find_largest_subnet(input);

    // Print the result for debugging
    dbg!(result);
}

/// Represents the graph as a mapping of nodes to their connections.
type NetworkGraph = HashMap<String, HashSet<String>>;

/// Parses the input string into a graph and a set of all vertices.
///
/// # Arguments
/// - `input`: A string representing the network connections in the format "node1-node2".
///
/// # Returns
/// A tuple containing:
/// - `NetworkGraph`: A mapping of nodes to their connected nodes.
/// - `HashSet<String>`: A set of all unique nodes (vertices).
fn parse_input(input: &str) -> (NetworkGraph, HashSet<String>) {
    let mut graph: NetworkGraph = HashMap::new();
    let mut vertices = HashSet::new();

    // Process each line to build the graph
    for line in input.lines() {
        let mut parts = line.split('-');
        let node_a = parts.next().unwrap().to_string();
        let node_b = parts.next().unwrap().to_string();

        // Add nodes to the vertices set
        vertices.insert(node_a.clone());
        vertices.insert(node_b.clone());

        // Add edges to the graph
        graph.entry(node_a.clone())
            .or_insert_with(HashSet::new)
            .insert(node_b.clone());
        graph.entry(node_b)
            .or_insert_with(HashSet::new)
            .insert(node_a);
    }

    (graph, vertices)
}

/// Finds the largest fully connected group (clique) in the network and returns its nodes
/// as a comma-separated string, sorted alphabetically.
///
/// # Arguments
/// - `input`: A string containing the network map.
///
/// # Returns
/// A string representing the largest fully connected group, with node names sorted and joined by commas.
fn find_largest_subnet(input: &str) -> String {
    let (graph, vertices) = parse_input(input);

    // List of all identified cliques
    let mut cliques: Vec<HashSet<String>> = Vec::new();

    // Sort vertices for consistent processing
    let mut sorted_vertices = vertices.into_iter().collect::<Vec<_>>();
    sorted_vertices.sort();

    // Build initial cliques by grouping compatible nodes
    for node in sorted_vertices {
        let neighbors = graph.get(&node).unwrap_or(&HashSet::new()).clone();

        // Try to add the current node to an existing compatible clique
        if let Some(existing_clique) = cliques.iter_mut().find(|clique| clique.is_subset(&neighbors)) {
            existing_clique.insert(node);
        } else {
            // Create a new clique with the current node
            let mut new_clique = HashSet::new();
            new_clique.insert(node);
            cliques.push(new_clique);
        }
    }

    // Attempt to expand cliques by adding compatible nodes
    let mut clique_extensions = HashMap::new();
    for (index, clique) in cliques.iter().enumerate() {
        let mut valid_candidates = Vec::new();

        for (node, connection) in &graph {
            if clique.contains(node) {
                continue;
            }

            // Check if the node is fully connected to the existing clique
            let mut temp_clique = clique.clone();
            temp_clique.extend(valid_candidates.clone());
            if connection.intersection(&temp_clique).count() == temp_clique.len() {
                valid_candidates.push(node.clone());
            }
        }

        clique_extensions.insert(index, valid_candidates);
    }

    // Find the largest clique after considering extensions
    let mut largest_clique: HashSet<String> = HashSet::new();
    for (index, extension) in clique_extensions {
        let mut extended_clique = cliques[index].clone();
        extended_clique.extend(extension);

        if extended_clique.len() > largest_clique.len() {
            largest_clique = extended_clique;
        }
    }

    // Convert the largest clique into a sorted, comma-separated string
    let mut sorted_clique: Vec<String> = largest_clique.into_iter().collect();
    sorted_clique.sort();
    sorted_clique.join(",")
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn test_find_largest_subnet() {
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

        let result = find_largest_subnet(input);
        assert_eq!(result, "co,de,ka,ta");
    }
}

