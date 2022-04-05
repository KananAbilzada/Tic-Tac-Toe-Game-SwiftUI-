//
//  Alerts.swift
//  Tic Tac Toe
//
//  Created by Kanan Abilzada on 04.04.22.
//

import SwiftUI

struct AlertItem: Identifiable {
    let id = UUID()
    
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin    = AlertItem(title: Text("You win!"),
                                message: Text("You are so smart :)"),
                                buttonTitle: Text("New Game"))
    
    static let computerWin    = AlertItem(title: Text("You lost!"),
                                message: Text("You programmed a super AI :)"),
                                buttonTitle: Text("Rematch"))
    
    static let draw    = AlertItem(title: Text("Draw!"),
                                message: Text("What a battle of wits we have here... :)"),
                                buttonTitle: Text("Try again"))
}
