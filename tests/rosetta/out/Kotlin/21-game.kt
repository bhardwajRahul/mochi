// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
fun _input(): String { return readLine() ?: "" }
// Code generated from 21-game.mochi

/**
 * Auto-generated from Mochi
 * @param str String
 * @return Int
 */
fun parseIntStr(str: String): Int {
    var i = 0
    var neg = false
    if (str.length > 0 && str.substring(0, 1) == "-") {
        neg = true
        i = 1
    }
    var n = 0
    val digits = mutableMapOf("0" to 0, "1" to 1, "2" to 2, "3" to 3, "4" to 4, "5" to 5, "6" to 6, "7" to 7, "8" to 8, "9" to 9)
    while (i < str.length) {
        n = n * 10 + digits[str.substring(i, i + 1)]
        i = i + 1
    }
    if (neg) {
        n = -n
    }
    return n
}

/**
 * Auto-generated from Mochi
 */
fun main(): Unit {
    var total = 0
    var computer = System.nanoTime().toInt() % 2 == 0
    println("Enter q to quit at any time\n")
    if (computer) {
        println("The computer will choose first")
    }
    else {
        println("You will choose first")
    }
    println("\n\nRunning total is now 0\n\n")
    var round = 1
    var done = false
    while (!done) {
        println("ROUND " + round.toString() + ":\n\n")
        var i = 0
        while (i < 2 && (!done)) {
            if (computer) {
                var choice = 0
                if (total < 18) {
                    choice = System.nanoTime().toInt() % 3 + 1
                }
                else {
                    choice = 21 - total
                }
                total = total + choice
                println("The computer chooses " + choice.toString())
                println("Running total is now " + total.toString())
                if (total == 21) {
                    println("\nSo, commiserations, the computer has won!")
                    done = true
                }
            }
            else {
                while (true) {
                    println("Your choice 1 to 3 : ")
                    val line = _input()
                    if (line == "q" || line == "Q") {
                        println("OK, quitting the game")
                        done = true
                        break
                    }
                    var num = parseIntStr(line)
                    if (num < 1 || num > 3) {
                        if (total + num > 21) {
                            println("Too big, try again")
                        }
                        else {
                            println("Out of range, try again")
                        }
                        continue
                    }
                    if (total + num > 21) {
                        println("Too big, try again")
                        continue
                    }
                    total = total + num
                    println("Running total is now " + total.toString())
                    break
                }
                if (total == 21) {
                    println("\nSo, congratulations, you've won!")
                    done = true
                }
            }
            println("\n")
            computer = !computer
            i = i + 1
        }
        round = round + 1
    }
}

