//  Swift Final Project
//  Name: RPC Adventure
//  Description: You know Rock/Paper/Scissors? well here's a terminal game that is based on that.
//  You play against enemies and deal damage if you win a round, you win when you beat everyone.
//  if you beat someone, you gain experience and can level up your damage to help you beat the rest.
//  author: Jacob South


import Foundation

//  The player class will be for both opponents and users.
//  it keeps track of levels and stats.

class Player {
    var stats: Dictionary<String, Int> = [:]
    let name: String
    var maxHP: Int

    fileprivate init(name: String, level: Int, hitpoints: Int, strength: Int) {
        self.name = name
        self.maxHP = hitpoints
        self.stats["level"] = level
        self.stats["hitpoints"] = hitpoints
        self.stats["strength"] = strength
    }
    var isDead: Bool { 
        get {
            let check = self.stats["hitpoints"] as? Int ?? 0
            if check <= 0{
                return true
            }
            else{
                return false
            }
        }
    }
    func takeDamage(amount: Int) {
        self.stats["hitpoints"]? -= amount
    }
    func reset() {
        self.stats["hitpoints"]? = maxHP
    }
    func increaseStat(statToIncrease: String, amountToIncrease: Int) {
        if statToIncrease == "hitpoints" {
            maxHP += amountToIncrease
        }
        self.stats[statToIncrease]? += amountToIncrease
    }
}

class Playable: Player { 
    fileprivate override init(name: String, level: Int, hitpoints: Int, strength: Int) {
        super.init(name: name, level: level, hitpoints: hitpoints, strength: strength)
        self.stats["experience"] = 0
    }
    func levelUp() {
        self.stats["level"]! += 1
        self.stats["hitpoints"]! += 2
        self.stats["strength"]! += 1
        self.maxHP += 2
        print("Level up! your level has gone up one level, and your stats have updated")
        print("Strength: \(self.stats["strength"]!)")
        print("Hit Points: \(self.maxHP)")
    }
    func printOptions() {
        print("\nInput 1 for Rock\nInput 2 for Paper\nInput 3 for Scissors\n")
    }
    enum inputs: Error {
        case invalid_type
        case out_of_scope
    }
    func fight(enemy: Player) {
        printOptions()
        while let input = readLine() {
            do {
                guard let inputAsInt = Int(input) else  {
                    throw inputs.invalid_type
                }

                guard 1...3 ~= inputAsInt else {
                    throw inputs.out_of_scope
                }

                //ask again:
                let rng = Int.random(in: 1..<4)
                switch rng {
                    case 1: enemy.stats["hitpoints"]! -= self.stats["strength"]!; print("Win! You dealt \(self.stats["strength"]!) damage to \(enemy.name), they have \(enemy.stats["hitpoints"]!) hp left") // Win
                    case 2: print("A tie!") // Tie
                    case 3: self.stats["hitpoints"]! -= enemy.stats["strength"]!; print("Lose! You lost \(enemy.stats["strength"]!) hp, you have \(self.stats["hitpoints"]!) hp left") // Lose
                    default: print("What did you do?")
                }
                if enemy.isDead {
                    print("\(enemy.name) has died")
                    levelUp()
                    break
                }
                else if self.isDead {
                    print("Player \(self.name) has died, restart to try again")
                    break
                }
                printOptions()
            }
            catch Playable.inputs.invalid_type {
                print("please enter an integer")
            }
            catch Playable.inputs.out_of_scope {
                print("please enter a number between 1 and 3 inclusive")
            }
            catch {
                print("Unknown error")
                break
            printOptions()
            
            }
        }
    }
}


func testInteraction() {
    var thePlayer = Playable(name: "Megamind", level: 1, hitpoints: 10, strength: 5)
    var theEnemy = Player(name: "Metroman", level: 99, hitpoints: 10000, strength: 600)
    thePlayer.fight(enemy: theEnemy)
}

func printWelcome() {
    print("Hello adventurer, welcome to a world where all combat is done with rock/paper/scissors.")
    print("You will fight 5 enemies, ranging from a simple grunt to the final boss!")
    print("Below is a list of the available enemies for you to fight.")
    print("Once you beat one, they are gone, but you will level up, helping you to beat stronger enemies")
    print("Once you beat the final boss, you win!")
    print("\n\nBut before all of that, lets name your character\n")
}

func createCharacter() -> Playable {
    var name: String = readLine() as? String ?? "Paul"
    if name.count == 0 {
        print("Fine, I'll name your character myself, his name is Paul")
        name = "Paul"
    }
    
    return Playable(name: name, level: 1, hitpoints: Int.random(in: 8...12), strength: Int.random(in: 3...7))
}

func printEnemies(roster: [String:Player]) {
    print("*----------------------------*")
    for player in roster.values {
        print("\(player.name), level \(player.stats["level"]!) ")
    }
    print("*----------------------------*\n")
}

func chooseEnemyToFight(choice: String, roster: [String:Player]) -> Player? {

    let returnValue = roster[choice] as? Player ?? nil
    return returnValue
}

enum errors : Error{
    case invalid_name
}

func runGame() {
    let grunt: Player = Player(name: "grunt", level: 1, hitpoints: 5, strength: 1)
    let bigMan: Player = Player(name: "Big Guy", level: 3, hitpoints: 15, strength: 2)
    let miniBoss: Player = Player(name: "Mini Boss" , level: 5 , hitpoints: 15, strength: 5)
    let minion: Player = Player(name: "Minion" , level: 4, hitpoints: 17, strength: 3)
    let finalBoss: Player = Player(name: "Final Boss" , level: 10, hitpoints: 20, strength: 8)
    var roster: [String:Player] = [grunt.name: grunt, bigMan.name: bigMan, miniBoss.name: miniBoss, minion.name: minion, finalBoss.name: finalBoss]
    
    printWelcome()
    print("Name your character")
    let playerCharacter = createCharacter()

    // Display the list of enemies
    print("\n")
    
    print("Choose an enemy from the roster by typing their name")
    print("Type \"exit\" to quit the game, your progress will not be saved\n")
    printEnemies(roster: roster)
    while let input = readLine() {
        do {
            guard input != "exit" else {
                print("Bye!")
                break
            }
        
            guard let chosenEnemy = chooseEnemyToFight(choice: input, roster: roster) else {
                print("please choose a valid name from the list of opponents")
                throw errors.invalid_name
            }
            
            playerCharacter.fight(enemy: chosenEnemy)
            if playerCharacter.isDead {
                break
            }
            if finalBoss.isDead {
                print("You saved the world!")
                break
            }
            else {
                roster.removeValue(forKey: chosenEnemy.name)
                playerCharacter.reset()
            }
        }
        catch {
            continue
        }
        print("\nChoose an enemy from the roster by typing their name")
        print("Type \"exit\" to quit the game, your progress will not be saved\n")
        printEnemies(roster: roster)
    }
}

runGame()
