import java.io.File

fun readInput(filePath: String): Array<CharArray> = File(filePath).readLines().map { it.toCharArray() }.toTypedArray()

enum class Direction(
    val orientation: Char,
) {
    UP('^'),
    RIGHT('>'),
    DOWN('v'),
    LEFT('<'),
    ;

    fun next(): Direction = values()[(ordinal + 1) % values().size]
}

data class Position(
    var coordinates: Pair<Int, Int>,
    var direction: Direction,
)

class Guard(
    var position: Position,
) {
    var inside = true

    init {
        require(position.coordinates.first >= 0 && position.coordinates.second >= 0) {
            "The position ${position.coordinates} contains negative coordinate values"
        }
    }

    fun takeStep(labMap: Array<CharArray>) {
        val nextPosition = lookAhead()
        when {
            !this.isInside(labMap, nextPosition) -> inside = false
            this.isObstacle(labMap, nextPosition) -> position.direction = position.direction.next()
            else -> position.coordinates = nextPosition
        }
    }

    private fun isInside(
        labMap: Array<CharArray>,
        coordinates: Pair<Int, Int>,
    ): Boolean = coordinates.second in labMap.indices && coordinates.first in labMap[coordinates.second].indices

    private fun isObstacle(
        labMap: Array<CharArray>,
        coordinates: Pair<Int, Int>,
    ): Boolean = labMap[coordinates.second][coordinates.first] in listOf('#', 'O')

    private fun lookAhead(): Pair<Int, Int> =
        when (position.direction) {
            Direction.UP -> position.coordinates.copy(second = position.coordinates.second - 1)
            Direction.RIGHT -> position.coordinates.copy(first = position.coordinates.first + 1)
            Direction.DOWN -> position.coordinates.copy(second = position.coordinates.second + 1)
            Direction.LEFT -> position.coordinates.copy(first = position.coordinates.first - 1)
        }
}

fun getStartingPosition(labMap: Array<CharArray>): Position {
    for (i in labMap.indices) {
        for (j in labMap[i].indices) {
            val direction = Direction.values().find { it.orientation == labMap[i][j] }
            if (direction != null) {
                return Position(Pair(j, i), direction)
            }
        }
    }
    throw IllegalArgumentException("No starting position found in the map")
}

fun getUniquePositions(labMap: Array<CharArray>): List<Position> {
    val uniquePositions = mutableSetOf<Position>()
    val startingPosition = getStartingPosition(labMap)
    val guard = Guard(startingPosition)

    while (guard.inside) {
        uniquePositions.add(guard.position.copy())
        guard.takeStep(labMap)
    }

    return uniquePositions.toList().distinctBy { it.coordinates }
}

fun findObstructionPositions(labMap: Array<CharArray>): MutableSet<Pair<Int, Int>> {
    val obstructionPositions = mutableSetOf<Pair<Int, Int>>()
    val possiblePositions = getUniquePositions(labMap)
    val startingPosition = getStartingPosition(labMap)

    for (position in possiblePositions) {
        // Forbidden to place obstruciton in guards starting position
        if (position.coordinates == startingPosition.coordinates) {
            continue
        }

        labMap[position.coordinates.second][position.coordinates.first] = 'O'
        val guard = Guard(startingPosition.copy())
        val visitedPositions = mutableSetOf<Position>()

        while (guard.inside) {
            guard.takeStep(labMap)
            if (guard.inside && !visitedPositions.add(guard.position.copy())) {
                obstructionPositions.add(position.coordinates.copy())
                break
            }
        }
        // Reset the map
        labMap[position.coordinates.second][position.coordinates.first] = '.'
    }
    return obstructionPositions
}

fun solutionPart2(labMap: Array<CharArray>): Int = findObstructionPositions(labMap).count()

fun main() {
    val labMap = readInput("input.txt")
    val result = solutionPart2(labMap)
    println("Obstructions can be placed in $result positions.")
}
