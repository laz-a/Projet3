//
//  Player.swift
//  Game
//
//  Created by laz on 10/05/2022.
//

import Foundation

//**********************
//MARK: - class Player
//**********************

final class Player {
    let name: String
    var team: Team = Team()
    let color: String
    
    //Player health point egal team hp
    var life: Int {
        return team.hp
    }
    
    //Check is player still alive
    var isAlive: Bool {
        return life > 0
    }
    
    //Number of turn = number of turn of the team
    var turn: Int {
        return team.turn
    }
    
    //Array of characters name
    var charactersNames: [String] = []
    
    //Player description
    var description: String {
        return """
        ============================================================
        Joueur : \(name)
        Équipe :
        \(team.description)
        ============================================================
        """
    }
    
    //Character ranking
    var ranking: String {
        return """
        ============================================================
        Joueur : \(name)
        Classement :
        \(team.ranking)
        ============================================================
        """
    }
    
    //Check if at least one of character in team can be healed
    var healCheck: Bool {
        for character in team.characters where character.canBeHealed {
                return true
        }
        return false
    }
    
    //Name characters
    private func newCharacterName(existingCharactersNames: [String]) -> String {
        if let name = readLine() {
            //Check if name already exist
            if !charactersNames.contains(name.lowercased()) && !existingCharactersNames.contains(name.lowercased()) && !name.isEmpty {
                self.charactersNames.append(name.lowercased())
                return name
            }
        }
        //If name already exist, enter a new name
        print("Un personnage avec ce nom existe déja !")
        print("Choisir un autre nom", terminator: " : ")
        return newCharacterName(existingCharactersNames: existingCharactersNames)
    }
    
    //Create new character
    private func newCharacter(existingCharactersNames: [String]) -> Character {
        //Display all character's type
        print("""
        Ajoute un membre à ton équipe :
        1. \(CharacterType.Saber.rawValue)
        2. \(CharacterType.Healer.rawValue)
        3. \(CharacterType.Berserker.rawValue)
        """)

        //Select type
        let choice: Int = Game.readInteger(in: 1...3, errorMessage: "Je n'ai pas compris ton choix")
        
        //Name the character
        print("Donne lui un nom", terminator: " : ")
        let name = newCharacterName(existingCharactersNames: existingCharactersNames)
        
        //Create character related to type and name
        switch choice {
        case 1: return Saber(name: name, player: self)
        case 2: return Healer(name: name, player: self)
        case 3: return Berserker(name: name, player: self)
        default: print("error")
        }
        
        return newCharacter(existingCharactersNames: existingCharactersNames)
    }
    
    init(name: String, color: String, existingCharactersNames: [String]) {
        self.name = name
        self.color = color
        
        //Team creation
        for n in 1...3 {
            let character: Character = newCharacter(existingCharactersNames: existingCharactersNames)
            print("Personnage \(n) :: \(character.description())")
            //Add character to team
            team.add(character: character)
        }
    }
    
    //Select character (for attack/heal)
    func selectCharacter() -> Character {
        let index: Int = Game.readInteger(in: 1...3, errorMessage: "Mauvais choix")
        let selectedCharacter: Character = team.characters[index - 1]
        
        //Check character hp
        if selectedCharacter.currentHp > 0 {
            return selectedCharacter
        }
        print("Le personnage est mort, choisir un autre personnage", terminator: " : ")
        return selectCharacter()
    }
    
    //Select the character to heal
    func selectCharacterToHeal() -> Character {
        let index: Int = Game.readInteger(in: 1...3, errorMessage: "Mauvais choix")
        let selectedCharacter: Character = team.characters[index - 1]
        //Test if selected character is dead or full hp
        if selectedCharacter.currentHp > 0 && selectedCharacter.currentHp < selectedCharacter.maxHp {
            return selectedCharacter
        }
        //if character is dead
        if selectedCharacter.currentHp == 0 {
            print("Le personnage est mort, choisir un autre personnage", terminator: " : ")
        }
        //if character if full hp
        else if selectedCharacter.currentHp == selectedCharacter.maxHp {
            print("Point de vie du personnage à 100%, choisir un autre personnage", terminator: " : ")
        }
        //if character is dead or full hp select another character
        return selectCharacterToHeal()
    }
}
