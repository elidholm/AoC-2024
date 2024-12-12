-- | Converts a dense disk map string into a list of (block size, file ID) pairs
expand :: [String] -> [(Int, Maybe Int)]
expand [diskMap] = reverse (processDiskMap [] 0 diskMap)
  where
    processDiskMap acc fileID [] = acc
    processDiskMap acc fileID (a : b : rest) =
        let fileSize = read [a] :: Int
            freeSpace = read [b] :: Int
        in processDiskMap ((freeSpace, Nothing) : (fileSize, Just fileID) : acc) (fileID + 1) rest
    processDiskMap acc fileID [a] = (read [a] :: Int, Just fileID) : acc
expand _ = error "Input must contain exactly one line."

-- | Rearranges file blocks to remove gaps and compacts the disk map
compact :: [(Int, Maybe Int)] -> [(Int, Maybe Int)]
compact blocks = rearrange [] blocks
  where
    rearrange acc [] = reverse acc
    rearrange acc xs
        | snd (last xs) == Nothing = rearrange acc (init xs) -- Remove trailing free space
        | snd (head xs) /= Nothing = rearrange (head xs : acc) (tail xs) -- Add file to result
        | otherwise = fillGap (head xs) (init (tail xs)) (last xs) acc

    fillGap (freeSpace, Nothing) middle (fileSize, Just fileID) acc
        | freeSpace == fileSize = rearrange ((fileSize, Just fileID) : acc) middle
        | freeSpace > fileSize = rearrange ((fileSize, Just fileID) : acc) ((freeSpace - fileSize, Nothing) : middle)
        | otherwise = rearrange ((freeSpace, Just fileID) : acc) (middle ++ [(fileSize - freeSpace, Just fileID)])
    fillGap _ _ _ _ = error "Unexpected error while compacting the disk map."

-- | Calculates the checksum for the compacted disk map
checksum :: [(Int, Maybe Int)] -> Int
checksum blocks = calculateChecksum 0 0 blocks
  where
    calculateChecksum position acc [] = acc
    calculateChecksum position acc ((size, Nothing) : rest) = calculateChecksum (position + size) acc rest
    calculateChecksum position acc ((size, Just fileID) : rest) =
        let delta = sum [fileID * p | p <- [position .. position + size - 1]]
        in calculateChecksum (position + size) (acc + delta) rest

-- | Reads input from a file
parseInput :: FilePath -> IO [String]
parseInput fileName = do
    content <- readFile fileName
    let linesOfFile = lines content
    return linesOfFile

-- | Main function to run the program
main :: IO ()
main = do
    -- Load the input file
    input <- parseInput "input.txt"
    let expanded = expand input
    let compacted = compact expanded

    -- Calculate and print the checksum
    let finalChecksum = checksum compacted
    putStrLn $ "Checksum for part 1: " ++ (show finalChecksum)

