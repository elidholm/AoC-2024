import Data.Maybe

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
compact blocks = rearrange blocks (reverse blocks)
    where
        rearrange xs [] = xs
        rearrange xs (y : ys)
            | isJust (snd y) = rearrange (move [] xs) ys
            | otherwise = rearrange xs ys
            where
                move acc (a : bs)
                    | snd a == snd y = xs
                    | isJust (snd a) = move (a : acc) bs
                    | fst a < fst y = move (a : acc) bs
                    | fst a == fst y = reverse acc ++ [y] ++ map edit bs
                    | fst a > fst y = reverse acc ++ [y, (fst a - fst y, Nothing)] ++ map edit bs
                move _ _ = error "cannot occur"
                edit a
                    | a == y = (fst y, Nothing)
                    | otherwise = a

-- | Calculates the checksum for the compacted disk map
checksum :: [(Int, Maybe Int)] -> Int
checksum = calculateChecksum 0 0
  where
    calculateChecksum position acc [] = acc
    calculateChecksum position acc ((size, Nothing) : rest) = calculateChecksum (position + size) acc rest
    calculateChecksum position acc ((size, Just fileID) : rest) =
        let delta = sum [fileID * p | p <- [position .. position + size - 1]]
        in calculateChecksum (position + size) (acc + delta) rest

-- | Reads and validates input from a file
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
    putStrLn $ "Checksum for part 2: " ++ show finalChecksum

