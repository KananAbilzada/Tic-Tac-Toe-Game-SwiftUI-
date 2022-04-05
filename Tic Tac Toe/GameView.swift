//
//  GameView.swift
//  Tic Tac Toe
//
//  Created by Kanan Abilzada on 04.04.22.
//

import SwiftUI

struct GameView: View {
    
    @StateObject private var viewModel = GameViewModel()
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                Spacer()

                LazyVGrid(columns: viewModel.columns) {
                    ForEach(0..<9) { i in
                        Circle()
                            .foregroundColor(.red).opacity(0.5)
                            .frame(width: geometry.size.width / CGFloat(viewModel.columns.count) - 15,
                                   height: geometry.size.width / CGFloat(viewModel.columns.count) - 15)
                            .overlay(
                                Image(systemName: viewModel.moves[i]?.indicator ?? "")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                            )
                            .onTapGesture {
                                /// check square marked or not
                                viewModel.playerMove(for: i)
                            }
                    }
                }
                .disabled(viewModel.isGameBoardDisabled)
                .alert("Alert title", isPresented: $viewModel.isAlertPresent, presenting: viewModel.alertContent) { alert in
                    Button("Ok") { }
                } message: { alert in
                    Text("\(alert.message)")
                }


                Spacer()
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        GameView()
    }
}

struct Move {
    let player: Player
    let boardIndex: Int
    
    var indicator: String {
        return player == .human ? "xmark" : "circle"
    }
}

enum Player {
    case human, computer
}
