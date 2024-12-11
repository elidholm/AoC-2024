import java.io.File

fun readInput(filePath: String): Array<CharArray> {
    return File(filePath).readLines().map { it.toCharArray() }.toTypedArray()
}

enum class Direction(val orientation: Char) {
    UP('^'), RIGHT('>'), DOWN('v'), LEFT('<');

    fun next(): Direction {
        return values()[(ordinal + 1) % values().size]
    }
}

data class Position(var coordinates: Pair<Int, Int>, var direction: Direction)

class Guard(var position: Position){
    var inside = true

    init {
        require(position.coordinates.first >= 0 && position.coordinates.second >= 0) {
            "The position ${position.coordinates} contains negative coordinate values"
        }
    }

    fun takeStep(labMap: Array<CharArray>) {
        val nextPosition = lookAhead()
        when {
            !this.isInside(labMap, nextPosition) ->  inside = false
            this.isObstacle(labMap, nextPosition) -> position.direction = position.direction.next()
            else -> position.coordinates = nextPosition
        }
    }

    private fun isInside(labMap: Array<CharArray>, coordinates: Pair<Int, Int>): Boolean {
        return coordinates.second in labMap.indices && coordinates.first in labMap[coordinates.second].indices
    }

    private fun isObstacle(labMap: Array<CharArray>, coordinates: Pair<Int, Int>): Boolean {
        return labMap[coordinates.second][coordinates.first] == '#'
    }

    private fun lookAhead(): Pair<Int, Int> {
        return when (position.direction) {
            Direction.UP -> position.coordinates.copy(second = position.coordinates.second - 1)
            Direction.RIGHT -> position.coordinates.copy(first = position.coordinates.first + 1)
            Direction.DOWN -> position.coordinates.copy(second = position.coordinates.second + 1)
            Direction.LEFT -> position.coordinates.copy(first = position.coordinates.first - 1)
        }
    }
}

fun getStartingPosition(labMap: Array<CharArray>): Position? {
    for (i in labMap.indices) {
        for (j in labMap[i].indices) {
            val direction = Direction.values().find { it.orientation == labMap[i][j] }
            if (direction != null) return Position(Pair(j, i), direction)
        }
    }
    return null
}

fun getUniquePositions(labMap: Array<CharArray>): List<Position> {
    val uniquePositions = mutableSetOf<Position>()
    val startingPosition = getStartingPosition(labMap) ?: throw IllegalArgumentException("No starting position found")
    val guard = Guard(startingPosition)

    while (guard.inside) {
        uniquePositions.add(guard.position.copy())
        guard.takeStep(labMap)
    }

    return uniquePositions.toList().distinctBy { it.coordinates }
}

fun solution_part1(labMap: Array<CharArray>): Int {
    return getUniquePositions(labMap).size
}

fun main() {
    val labMap: Array<CharArray> = readInput("input.txt")
    val result: Int = solution_part1(labMap)
    println("The guard will visit $result unique positions.")
}
