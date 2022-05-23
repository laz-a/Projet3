//
//  Game.swift
//  Game
//
//  Created by laz on 10/05/2022.
//

import Foundation

//**********************
//MARK: - class Game
//**********************

final class Game {
    //Players
    private var players: [Int: Player] = [:]
    
    //Set winner
    private var winner: Player?
    
    //Players color (for terminal print)
    private let colors: [String] = ["\u{001B}[0;36m", "\u{001B}[0;33m"]
    
    //Array of players name
    private var playersNames: [String] = []
    
    //Array of characters name
    private var charactersNames: [String] {
        var cn: [String] = []
        for (_, player) in players {
            cn.append(contentsOf: player.charactersNames)
        }
        return cn
    }

    //Player creation
    private func newPlayer(_ i: Int) -> Player {
        print("Joueur \(i)", terminator: " : ")
        let name: String = newPlayerName(i)
        
        //Player creation
        let player: Player = Player(name: name, color: colors[i - 1], existingCharactersNames: charactersNames)
        
        Game.colorPrint(color: player.color, content: player.description)
        
        return player
    }
    
    //Name players
    private func newPlayerName(_ i: Int) -> String {
        if let name = readLine() {
            if name.isEmpty {
                let defaultName: String = "Player \(i)" //Default name : Joueur 1
                playersNames.append(defaultName.lowercased())
                return defaultName
            }
            //Check if player name already exist
            if !playersNames.contains(name.lowercased()) {
                playersNames.append(name.lowercased())
                return name
            }
        }
        //If name already exist, enter a new name
        print("Un joueur avec ce nom existe déja !")
        print("Choisir un nouveau nom", terminator: " : ")
        return newPlayerName(i)
    }
    
    //Enter integer only with condition
    static func readInteger(in condition: ClosedRange<Int>, errorMessage message: String) -> Int {
        if let input = readLine() {
            if let int: Int = Int(input), condition ~= int {
                //Return valid integer
                return int
            }
        }
        //If error, enter a new value
        print(message, terminator: " : ")
        return readInteger(in : condition, errorMessage: message)
    }
    
    //Custom print with color
    static func colorPrint(color: String, content: String) {
        print("\(color)\(content)\u{001B}[0;0m")
    }
    
    init() {
        //Player 1 creation
        players[1] = newPlayer(1)
        
        //Player 2 creation
        players[2] = newPlayer(2)

        //Players summary
        print("\nLes joueurs sont prêts :")
        for (_, player) in players {
            Game.colorPrint(color: player.color, content: player.description)
        }
    }
    
    func fight() {
        //if player 1 and player 2 exist
        if let player1 = players[1], let player2 = players[2] {
            //Number of turn
            var turn: Int = 1
            
            //Game continue while both players still alive
            while player1.isAlive && player2.isAlive {
                //Attacker and target changes every turn
                let attackerPlayer: Player = turn % 2 == 1 ? player1 : player2
                let targetPlayer: Player = turn % 2 == 1 ? player2 : player1
                
                print("\nTour \(turn) :: \(attackerPlayer.color + attackerPlayer.name)\u{001B}[0;0m")
                
                //Attacker player detail
                Game.colorPrint(color: attackerPlayer.color, content: attackerPlayer.description)
                
                //Select character
                print("Choisi ton personnage :", terminator: " ")
                let selectedCharacter: Character = attackerPlayer.selectCharacter()
                
                print("Personnage :: \(attackerPlayer.color)\(selectedCharacter.description())\u{001B}[0;0m")
                
                Game.colorPrint(color: attackerPlayer.color, content: "1. Attaque")
                if selectedCharacter is Healer && attackerPlayer.healCheck {
                    Game.colorPrint(color: attackerPlayer.color, content: "2. Soin")
                }
                
                //Select attack or heal(for healer only)
                print("Choisir l'action", terminator: " : ")
                
                let range: ClosedRange<Int> = (selectedCharacter is Healer && attackerPlayer.healCheck) ? 1...2 : 1...1
                let action: Int = Game.readInteger(in: range, errorMessage: "Choisir une autre action")
                
                print("\n")
                
                //Do the action (attack / heal)
                if action == 1 {
                    Game.colorPrint(color: targetPlayer.color, content: targetPlayer.team.description)
                    
                    //Select character to attack
                    print("Choisir le personnage à attaquer", terminator: " : ")
                    let targetCharacter: Character = targetPlayer.selectCharacter()
                    selectedCharacter.attack(targetCharacter)
                } else if let selectedHealer = selectedCharacter as? Healer, action == 2 {
                    Game.colorPrint(color: attackerPlayer.color, content: attackerPlayer.team.description)
                    
                    //Select character to heal
                    print("Choisir le personnage à soigner", terminator: " : ")
                    let selectedTargetCharacter: Character = attackerPlayer.selectCharacterToHeal()
                    selectedHealer.heal(selectedTargetCharacter)
                }
                
                _ = readLine()
                print("\n\n\n")
                
                //Increment number of turn
                turn += 1
            }
            
            //Set winner
            winner = player1.life > 0 ? player1 : player2
        }
    }
    
    //Game over, display winner with stat
    func over() {
        if let w = winner {
            
            //Total turn = sum of players turn
            var totalTurn: Int = 0
            for (_, player) in players {
                totalTurn += player.turn
            }
            
            //Display winner
            Game.colorPrint(color: w.color, content: "\(w.name) à gagné en \(w.turn) tours !")
            //Display player detail and character ranking
            Game.colorPrint(color: w.color, content: w.ranking)
            
            print("\nNombre total de tour : \(totalTurn)")
        }
    }
}
