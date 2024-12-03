//> using scala 3.6.1

package part1

import scala.io.Source
import scala.io.BufferedSource

object Part1:

  def readInput(file_name: String): List[List[Int]] =
    val bufferedInput: BufferedSource = Source.fromFile(file_name)
    bufferedInput.getLines().map(_.split("\\s+").map(_.toInt).toList).toList

  def isSafe(list: List[Int]): Boolean =
    val ascending: Boolean = list.head < list.tail.head
    list.sliding(2).forall { case List(a, b) => if ascending then a < b && b-a <= 3 else a > b && a-b <= 3 }

  @main
  def solution: Unit =
    val reports: List[List[Int]] = readInput("input.txt")
    val result: Int = reports.count(isSafe)

    println(result)

