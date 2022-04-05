//
//  GameViewModel.swift
//  Tic Tac Toe
//
//  Created by Kanan Abilzada on 05.04.22.
//

import SwiftUI

final class GameViewModel: ObservableObject {
    var columns: [GridItem] = [
        GridItem(.adaptive(minimum: 100, maximum: 200), spacing: 0),
        GridItem(.adaptive(minimum: 100, maximum: 200), spacing: 0),
        GridItem(.adaptive(minimum: 100, maximum: 200), spacing: 0)
    ]

    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameBoardDisabled: Bool = false
    @Published var isAlertPresent: Bool = false
    @Published var alertContent: AlertItem?
    
    func playerMove(for index: Int) {
        if !isSquareOccupied(in: moves, forIndex: index) {
            /// add clicked square to human
            moves[index] = Move(player: .human, boardIndex: index)
            isGameBoardDisabled = true
            
            /// check win condition
            if checkWinCondition(player: .human, in: moves) {
                print("human wins")
                alertContent = AlertContext.humanWin
                isAlertPresent = true
                return
            }
            
            if checkForDraw(in: moves) {
                print("draw")
                alertContent = AlertContext.draw
                isAlertPresent = true
                return
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.computerRunStep()
            }
        }
    }
    
    func computerRunStep() {
        let randomStep = determineComputerMovePosition(in: moves)
        moves[randomStep] = Move(player: .computer, boardIndex: randomStep)
        
        /// open board for human clicking
        if checkWinCondition(player: .computer, in: moves) {
            print("computer wins")
            alertContent = AlertContext.computerWin
            isAlertPresent = true
            return
        }
        
        if checkForDraw(in: moves) {
            print("draw")
            alertContent = AlertContext.draw
            isAlertPresent = true
            return
        }
        
        isGameBoardDisabled = false
    }
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains(where: {$0?.boardIndex == index})
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        /// AI can win position
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [2,4,6], [0,4,8]]
        
        let playerMoves     = moves.compactMap({ $0 }).filter { $0.player == .computer }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(playerPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        /// human win position
        let humanMoves     = moves.compactMap({ $0 }).filter { $0.player == .human }
        let humanPositions = Set(humanMoves.map { $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            
            if winPositions.count == 1 {
                let isAvailable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvailable { return winPositions.first! }
            }
        }
        
        /// if middle square is available, take it
        if !isSquareOccupied(in: moves, forIndex: 4) {
            return 4
        }
        
        /// if middle square isn't available, take random square
        var movePosition: Int = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition) {
            movePosition = Int.random(in: 0..<9)
        }
        
        return movePosition
    }
    
    func checkWinCondition(player: Player, in moves: [Move?]) -> Bool {
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5], [6,7,8], [0,3,6], [1,4,7], [2,5,8], [2,4,6], [0,4,8]]
        
        let playerMoves     = moves.compactMap({ $0 }).filter { $0.player == player }
        let playerPositions = Set(playerMoves.map { $0.boardIndex })
        
        for pattern in winPatterns where pattern.isSubset(of: playerPositions) { return true }
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
}
