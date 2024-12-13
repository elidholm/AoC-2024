(* Read the file into a 2D array of characters *)
let read_file_as_char_array filename =
    try
        let input_channel = open_in filename in
        let rec read_lines acc =
            try
                let line = input_line input_channel in
                read_lines (Array.of_list (List.init (String.length line) (String.get line)) :: acc)
            with End_of_file ->
                close_in input_channel;
        Array.of_list (List.rev acc)
                in
    read_lines []
            with Sys_error err ->
                Printf.eprintf "Error: %s\n" err;
                [||]

(* Define a module for comparing integer pairs *)
module IntPairs = struct
    type t = int * int
    let compare (x0, y0) (x1, y1) =
        let cmp_x = Stdlib.compare x0 x1 in
        if cmp_x = 0 then Stdlib.compare y0 y1 else cmp_x
end

(* Use Map to keep track of visited cells *)
module PairsMap = Map.Make(IntPairs)

(* Safely get a character from the 2D array, return '.' if out of bounds *)
let safe_get arr row col =
    if row < 0 || row >= Array.length arr || col < 0 || col >= Array.length arr.(row)
    then '.'
    else arr.(row).(col)

(* Get the cardinal (N, S, E, W) neighbors of a cell *)
let get_neighbors_card arr (row, col) =
    [
        (safe_get arr (row + 1) col, (row + 1, col));
        (safe_get arr (row - 1) col, (row - 1, col));
        (safe_get arr row (col + 1), (row, col + 1));
        (safe_get arr row (col - 1), (row, col - 1));
    ]

(* Get the diagonal (NW, NE, SW, SE) neighbors of a cel *)
let get_neighbors_diag arr (row, col) =
    [
        (safe_get arr (row + 1) (col + 1), (row + 1, col + 1));
        (safe_get arr (row - 1) (col + 1), (row - 1, col + 1));
        (safe_get arr (row - 1) (col - 1), (row - 1, col - 1));
        (safe_get arr (row + 1) (col - 1), (row + 1, col - 1));
    ]

(* Count valid corners formed by cardinal and diagonal neighbors *)
let get_n_corners card_els diag_els =
    let gc (el, _) = el in
    let card = Array.of_list card_els in
    let diag = Array.of_list diag_els in
    let test (c1, c2, d) =
        if c1 = c2 && (c1 = '.' || d = '.') then 1 else 0
    in

    let corners =
        [
            test (gc card.(0), gc card.(2), gc diag.(0));
            test (gc card.(0), gc card.(3), gc diag.(3));
            test (gc card.(1), gc card.(2), gc diag.(1));
            test (gc card.(1), gc card.(3), gc diag.(2));
        ]
    in
    List.fold_left ( + ) 0 corners

(* Main solving function *)
let solve arr =
    let visited = ref PairsMap.empty in
    let rec explore (row, col) =
        if PairsMap.mem (row, col) !visited then (0, 0)
        else (
            visited := PairsMap.add (row, col) true !visited;
            let cell_value = safe_get arr row col in
            let card_neighbors =
                List.map (fun (el, pos) -> if el = cell_value then (el, pos) else ('.', pos))
                    (get_neighbors_card arr (row, col))
            in
            let diag_neighbors =
                List.map (fun (el, pos) -> if el = cell_value then (el, pos) else ('.', pos))
                    (get_neighbors_diag arr (row, col))
            in
            let corners = get_n_corners card_neighbors diag_neighbors in
            let valid_neighbors = List.filter (fun (el, _) -> el = cell_value) card_neighbors in
            let neighbor_results = List.map (fun (_, pos) -> explore pos) valid_neighbors in
            List.fold_left (fun (total_cells, total_corners) (cells, corners) ->
                (total_cells + cells, total_corners + corners)) (1, corners) neighbor_results
        )
    in
    let mapped =
        Array.mapi (fun row line ->
            Array.mapi (fun col _ -> explore (row, col)) line
        ) arr
    in
    Array.fold_left (fun total line ->
        Array.fold_left (fun acc (cells, corners) -> acc + (cells * corners)) total line
    ) 0 mapped

(* Main Entry point of code *)
let () =
    let filename = "input.txt" in
    let char_array = read_file_as_char_array filename in
    if Array.length char_array > 0 then
        let total_cost = solve char_array in
        Printf.printf "Total cost for fencing: %d\n" total_cost
    else
        Printf.printf "No valid data in the input file.\n"

