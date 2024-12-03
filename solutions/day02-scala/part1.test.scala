//> using test.dep org.scalatest::scalatest::3.2.19

package part1

import org.scalatest._
import org.scalatest.flatspec._
import org.scalatest.matchers._


class TestPart1 extends AnyFlatSpec with should.Matchers {
  "isSafe" `should` "identify safe sequences correctly" in {
    val testSequence = List(1, 2, 3)
    Part1.isSafe(testSequence) `shouldBe` true

    val unsafeSequence = List(2, 3, 1)
    Part1.isSafe(unsafeSequence) `shouldBe` false
  }
}
