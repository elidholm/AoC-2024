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

(* Safely get a character from the 2D array, returning '.' for out-of-bounds *)
let safe_get arr row col =
    if row < 0 || row >= Array.length arr || col < 0 || col >= Array.length arr.(row)
    then '.'
    else arr.(row).(col)

(* Get neighbors of a cell, returning their characters and coordinates *)
let get_neighbors arr (row, col) =
    [
        (safe_get arr (row + 1) col, (row + 1, col));
        (safe_get arr (row - 1) col, (row - 1, col));
        (safe_get arr row (col + 1), (row, col + 1));
        (safe_get arr row (col - 1), (row, col - 1));
    ]

(* Compute the area and perimeter of a region using DFS *)
let compute_region arr visited start =
    let rec dfs (area, perimeter) stack =
        match stack with
        | [] -> (area, perimeter)
        | (row, col) :: rest ->
            if Hashtbl.mem visited (row, col) then dfs (area, perimeter) rest
            else
                let cell = safe_get arr row col in
                Hashtbl.add visited (row, col) true;
                let neighbors = get_neighbors arr (row, col) in
                let new_area = area + 1 in
                let new_perimeter, next_stack =
                    List.fold_left
                        (fun (p, s) (neighbor_char, pos) ->
                            if neighbor_char = cell then (p, pos :: s)
                            else (p + 1, s))
                        (perimeter, rest)
                        neighbors
                in
                dfs (new_area, new_perimeter) next_stack
    in
    dfs (0, 0) [start]

(* Solve the problem: calculate the total fencing cost *)
let solve arr =
    let visited = Hashtbl.create (Array.length arr * Array.length arr.(0)) in
    let total_cost = ref 0 in
    Array.iteri (fun row line ->
        Array.iteri (fun col cell ->
            if not (Hashtbl.mem visited (row, col)) then
                let (area, perimeter) = compute_region arr visited (row, col) in
                total_cost := !total_cost + (area * perimeter)
                ) line
        ) arr;
   !total_cost

(* Main function *)
let () =
    let char_array = read_file_as_char_array "input.txt" in
    let total_cost = solve char_array in
    Printf.printf "Total cost for fencing: %d\n" total_cost

