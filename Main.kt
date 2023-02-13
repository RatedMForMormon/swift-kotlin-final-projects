import kotlin.random.Random

// Rock, Paper, Scissors RPG
// There is a Player class, and a child class called Playable
// Player class has hp, strength, level, maxHp, and isDead.
// Functions, reset(), it will set their hp to their maxhp

// Playable will have a fight() function that takes a player as a parameter, it rolls aginst a random table after user input
// it then either does nothing, deals strength damage to the player or to the enemy

open class Player(open var name: String, level: Int, strength: Int, maxHP: Int) {
    var stats = hashMapOf<String, Int>()

    init {
        stats["level"] = level
        stats["strength"] = strength
        stats["maxHP"] = maxHP
        stats["hitpoints"] = maxHP
    }

    val isDead: Boolean
        get() {
            return stats["hitpoints"]!! <= 0
        }


    fun reset(){
        stats["hitpoints"] = stats["maxHP"]!!
    }

    fun takeDamage(amount: Int?): Int {
        stats["hitpoints"] = stats["hitpoints"]!! - amount!!
        return stats["hitpoints"]!!
    }
}

class Playable(override var name: String, level: Int, strength: Int, maxHP: Int): Player(name, level, strength, maxHP) {

    private fun levelUp() {
        this.stats["level"] = this.stats["level"]!! + 1
        this.stats["strength"] = this.stats["strength"]!! + 2
        this.stats["maxHP"] = this.stats["maxHP"]!! + 3
        this.stats["hitpoints"] = this.stats["maxHP"]!!
        println("Level up! your level has gone up one level, and your stats have updated")
        println("Strength: ${stats["strength"]!!}")
        println("Hit Points: ${stats["maxHP"]!!}")
    }

    fun fight(other: Player) : Boolean{
        while (!other.isDead && !isDead) {
            println("Press 1 for rock.")
            println("Press 2 for paper.")
            println("Press 3 for scissors.\n")
            val input = readln()
            if (input.toInt() !in 1..3) {
                println("Please only type 1, 2, or 3\n")
                continue
            }
            val rng = Random.nextInt(from = 1, until = 4)
            when (rng) {
                1 -> print(
                    "Win, $name dealt ${stats["strength"]} damage to ${other.name}, they now have ${
                        other.takeDamage(
                            stats["strength"]
                        )
                    } health\n"
                )

                2 -> print("Tie, nothing happened.\n")
                3 -> print(
                    "Lose, ${other.name} dealt ${other.stats["strength"]} damage to you. You now have ${
                        this.takeDamage(
                            other.stats["strength"]
                        )
                    } health\n"
                )
            }
            if (isDead) {
                println("$name died! restart to try again.")
                return false
            }
            else if (other.isDead) {
                levelUp()
                return true
            }
        }
        return false
    }
}


fun test0() {
    println("TEST 0======================================================")
    var megaMind = Playable("Megamind", 5, 10, 30)
    var metroMan = Player("Metroman", 600, 10000, 50000)

    megaMind.fight(metroMan)
    megaMind.fight(metroMan)
    megaMind.fight(metroMan)
    megaMind.fight(metroMan)
}

fun test1() {
    println("TEST 1======================================================")
    var megaMind = Player("Megamind", 5, 10, 30)
    var metroMan = Playable("Metroman", 600, 10000, 50000)
    metroMan.fight(megaMind)
    metroMan.fight(megaMind)
    metroMan.fight(megaMind)
    metroMan.fight(megaMind)
}

fun test2() {
    println("TEST 2======================================================")
    var count = 0
    for (i in 0..10000) {
        var megaMind = Player("Megamind", 5, 10, 30)
        var metroMan = Playable("Metroman", 600, 10000, 50000)
        if (!metroMan.fight(megaMind)) {
            count += 1
        }
    }
    print(count)
}

fun printWelcome() {
    println("Welcome message")
}

fun runGame() {
    var defaultCharacter = Playable("Main Character", 1, 5, 10)
    var defaultEnemy = Player("grunt", 1, 3, 7)
    var bigGuy = Player("big guy", 3, 5, 15)
    var minion = Player("minion", 2, 4, 12)
    var miniboss = Player("miniboss", 4, 7, 17)
    var finalBoss = Player("Final Boss", 5, 10, 20)
    printWelcome()
    var playerList: HashMap<String, Player> = HashMap<String, Player>()
    playerList[defaultEnemy.name] = defaultEnemy
    playerList[bigGuy.name] = bigGuy
    playerList[minion.name] = minion
    playerList[miniboss.name] = miniboss
    playerList[finalBoss.name] = finalBoss


    while (playerList.isNotEmpty()) {
        print("\nSelect an opponent by typing their name:\n")
        println("==============================================")
        for (player in playerList.values) {
            println("${player.name}, level ${player.stats["level"]}")
        }
        println("==============================================")
        println()
        var input: String = readln()
        while (!playerList.containsKey(input)){
            print("Please choose a valid name\n")
            input = readln()
        }
        if (defaultCharacter.fight(playerList[input]!!)) {
            playerList.remove(input)
            defaultCharacter.reset()
            if (input == "Final Boss") {
                print("You win the game!")
                break
            }
        }
        else {
            break
        }
    }
}

fun main(args: Array<String>) {
    //test0()
    //test1()
    //test2()

    runGame()



    // Try adding program arguments via Run/Debug configuration.
    // Learn more about running applications: https://www.jetbrains.com/help/idea/running-applications.html.
    // println("Program arguments: ${args.joinToString()}")
}