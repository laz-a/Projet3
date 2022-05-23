//
//  Character.swift
//  Game
//
//  Created by laz on 10/05/2022.
//

import Foundation

//**********************
//MARK: - class Character
//**********************

//Character's type
enum CharacterType: String {
    case Saber
    case Healer
    case Berserker
}

//Parent class
class Character {
    var player: Player
    var type: CharacterType = .Saber
    var name: String
    var weapon: String = ""
    
    //Max health point
    var maxHp: Int
    
    //Current health point, can't be < 0 and > maxHp
    var currentHp: Int {
        didSet {
            if currentHp < 0 {
                currentHp = 0
            } else if currentHp > maxHp {
                currentHp = maxHp
            }
        }
    }
    
    //Test if character can be heal
    var canBeHealed: Bool {
        return currentHp > 0 && currentHp < maxHp
    }
    
    //Attack power
    var attack: Int = 10
    
    //Attack count
    var numberOfAttack: Int = 0
    
    //number of turn = number of attack
    var turn: Int {
        return numberOfAttack
    }
    
    init(name: String, player: Player) {
        self.player = player
        self.name = name
        currentHp = 100
        maxHp = currentHp
    }
    
    //Return emoji for full hp, dead and hurt
    func getEmoji() -> String {
        var emoji: String
        
        switch currentHp {
        case 0: emoji = "👻"
        case 1..<maxHp: emoji = "❤️‍🩹 "
        default: emoji = "❤️ "
        }
        
        return emoji
    }
    
    //Character description, detail for game over
    func description(detail: Bool = false) -> String {
        let emoji: String = getEmoji()
        var desc = "\(emoji) \(name) :: \(type.rawValue) :: (hp/atk) (\(currentHp)/\(attack))"
        if detail {
            desc += " || Attaque : \(numberOfAttack)"
        }
        return desc
    }
    
    //Attack
    func attack(_ target: Character) {
        //Print attack informations
        print("""
        \nCible :: \(target.player.color)\(target.description())
        \n\(player.color)\(player.name) :: \(name) \u{001B}[0;0mVS \(target.player.color)\(target.player.name) :: \(target.name)
        \(player.color)\(name) attaque \(target.name) avec :: \(weapon) :: \(attack)
        """)
        
        //Attack target character
        target.currentHp -= attack
        
        //Add 1 to number of attack
        numberOfAttack += 1
        Game.colorPrint(color: target.player.color, content: target.player.description)
    }
}

//Class character type : Saber
final class Saber: Character {
    override init(name: String, player: Player) {
        super.init(name: name, player: player)
        type = .Saber
        weapon = "Épée"
        currentHp = 100
        maxHp = currentHp
        attack = 20
    }
}

//Class character type : Healer
final class Healer: Character {
    //Heal point
    let heal: Int = 15
    
    //Count number of heal
    private var numberOfHeal: Int = 0
    
    //Number of turn = numbre of attack + number of heal
    override var turn: Int {
        return numberOfAttack + numberOfHeal
    }
    
    override init(name: String, player: Player) {
        super.init(name: name, player: player)
        type = .Healer
        weapon = "Sceptre"
        currentHp = 120
        maxHp = currentHp
        attack = 10
    }
    
    //Different description (add heal detail)
    override func description(detail: Bool = false) -> String {
        let emoji: String = getEmoji()
        var desc = "\(emoji) \(name) :: \(type.rawValue) :: (hp/atk/rcv)(\(currentHp)/\(attack)/\(heal))"
        if detail {
            desc += " || Attaque : \(numberOfAttack) | Soin : \(numberOfHeal)"
        }
        return desc
    }
    
    //Heal
    func heal(_ target: Character) {
        //Print heal information
        print("""
        \(name) soigne \(target.name)
        Soin :: \(player.color)\(target.description())
        """)
        
        target.currentHp += heal
        
        //Add 1 turn of heal
        numberOfHeal += 1
        Game.colorPrint(color: player.color, content: player.description)
    }
}

//Class character type : Berserker
final class Berserker: Character {
    override init(name: String, player: Player) {
        super.init(name: name, player: player)
        type = .Berserker
        weapon = "Hache"
        currentHp = 75
        maxHp = currentHp
        attack = 60
    }
}
