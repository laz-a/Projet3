//
//  Team.swift
//  Game
//
//  Created by laz on 10/05/2022.
//

import Foundation

//**********************
//MARK: - class Team
//**********************

final class Team {
    //Array of character in team
    var characters: [Character] = []
    
    //Team hp egal the sum of characters hp
    var hp: Int {
        return characters.reduce(0) { $0 + $1.currentHp }
    }
    
    //Number of total turn (attack and heal)
    var turn: Int {
        return characters.reduce(0) { $0 + $1.turn }
    }
    
    //Team description
    var description: String {
        var desc: String = ""
        for (index, c) in characters.enumerated() {
            desc += ((index > 0) ? "\n" : "") + "\(index + 1) - \(c.description(detail: false))"
        }
        return desc
    }
    
    //Ranking of the best characters
    var ranking: String {
        //Sort by number of attack/heal
        let sortedCharacters = characters.sorted {
            $0.turn > $1.turn
        }
        
        var desc: String = ""
        //Formatting ranking display
        for (index, character) in sortedCharacters.enumerated() {
            desc += ((index > 0) ? "\n" : "")
            if index == 0 {
                desc += "  "
            } else if index == 1 {
                desc += " "
            }
            desc += "\(index + 1) \(character.description(detail: true))"
        }
        
        return desc
    }
    
    //Add character to team
    func add(character: Character) {
        self.characters.append(character)
    }
}
