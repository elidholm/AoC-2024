//> using scala 3.6.1

import scala.io.Source
import scala.io.BufferedSource

object Part2:

  def readInput(file_name: String): List[List[Int]] =
    val bufferedInput: BufferedSource = Source.fromFile(file_name)
    bufferedInput.getLines().map(_.split("\\s+").map(_.toInt).toList).toList

  def isSafe(report: List[Int]): Boolean =
    val ascending: Boolean = report.head < report.tail.head
    report.sliding(2).forall { case List(a, b) => if ascending then a < b && b-a <= 3 else a > b && a-b <= 3 }


  def dampenedVariations(report: List[Int]): Seq[List[Int]] = report.indices.map(report.patch(_, Nil, 1))

  @main
  def solution: Unit =
    val reports: List[List[Int]] = readInput("input.txt")
    val result: Int = reports.count(dampenedVariations(_).exists(isSafe))

    println(result)

