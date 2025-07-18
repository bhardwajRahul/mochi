// Generated by Mochi compiler v0.10.28 on 2006-01-02T15:04:05Z
// Code generated from checkpoint-synchronization-4.mochi

var nMech = 5

var detailsPerMech = 4

fun main() {
    for (mech in 1 until (nMech + 1)) {
        val id = mech
        println("worker " + id.toString() + " contracted to assemble " + detailsPerMech.toString() + " details")
        println("worker " + id.toString() + " enters shop")
        var d = 0
        while (d < detailsPerMech) {
            println("worker " + id.toString() + " assembling")
            println("worker " + id.toString() + " completed detail")
            d = d + 1
        }
        println("worker " + id.toString() + " leaves shop")
        println("mechanism " + mech.toString() + " completed")
    }
}
