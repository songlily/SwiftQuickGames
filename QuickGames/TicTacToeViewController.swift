//
//  TicTacToeViewController.swift
//  QuickGames
//
//  Created by Lily Song on 2017-12-15.
//  Copyright © 2017 Lily Song. All rights reserved.
//

import UIKit

class TicTacToeViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!      //auto sorted by tags 1-9
    private var game = ["", "", "",
                        "", "", "",
                        "", "", ""]
        {
        didSet {
            if checkForWinner() == nil && !gameOver {
                currentPlayer = currentPlayer.switchPlayer()
                if currentPlayer == .O {
                    aiMakeMove()
                }
            }
        }
        
    }
    
    //     buttons = [1, 2, 3,      game = [0, 1, 2,
    //                4, 5, 6,              3, 4, 5,
    //                7, 8, 9]              6, 7, 8]
    
    private let wins = [[0, 1, 2], [3, 4, 5], [6, 7, 8],          //rows
                        [0, 3, 6], [1, 4, 7], [2, 5, 8],          //columns
                        [0, 4, 8], [2, 4, 6]]                     //diagonals

    
    var currentPlayer: Player = .X //: Player!
    var gameOver = false
    
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var myScoreLabel: UILabel!
    @IBOutlet weak var aiScoreLabel: UILabel!
    var myScore = 0
    var aiScore = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
        replayButton.isHidden = true
//        buttons.sort {
//            $0.tag < $1.tag
//        }
    }
    
    private func startGame() {
        currentPlayer = currentPlayer.firstPlayer()
        if currentPlayer == .O {
            aiMakeMove()
        }
    }
    
    @IBAction private func makeMove(_ sender: UIButton) {
        let play = sender.tag - 1
        guard (game[play] == "" && !gameOver) else { return }
        
        sender.setTitle("X", for: .normal)   //change button
        game[play] = "X"                    //record in game
        
//        game[play] = currentPlayer.rawValue                     //record in game
//        sender.setTitle(currentPlayer.rawValue, for: .normal)   //change button
        
    }
    
    private func aiMakeMove() {
        var played = false
        
        //make winning move if any
        for win in wins {
            guard !played else { return }
            
            if     (game[win[0]] == game[win[1]] && game[win[0]] == "O")
                || (game[win[0]] == game[win[2]] && game[win[0]] == "O")
                || (game[win[1]] == game[win[2]] && game[win[1]] == "O") {
                for num in 0...2 {
                    if game[win[num]] == "" {
                        buttons[win[num]].setTitle("O", for: .normal)
                        game[win[num]] = "O"
                        
                        played = true
                    }
                }
            }
        }
        
        //block human's winning move if any
        for win in wins {
            guard !played else { return }
            
            if ((game[win[0]] == game[win[1]] || game[win[0]] == game[win[2]]) && game[win[0]] == "X")
                || (game[win[1]] == game[win[2]] && game[win[1]] == "X") {
                for num in 0...2 {
                    if game[win[num]] == "" {
                        buttons[win[num]].setTitle("O", for: .normal)
                        game[win[num]] = "O"
                        
                        played = true
                    }
                }
            }
        }
        
        //else best move/random
        guard !played else { return }
        
        var num: Int
        repeat { num = Int(arc4random_uniform(9)) }
            while (game[num] != "")
        
        buttons[num].setTitle("O", for: .normal)
        game[num] = "O"
        
        played = true
        
    }
    
    private func checkForWinner() -> Player? {
        guard !gameOver else { return nil }
        
        //check win
        for win in wins {
            if game[win[0]] != "",
               game[win[0]] == game[win[1]],
               game[win[1]] == game[win[2]] {
                gameOver = true
                resultLabel.text = "\(game[win[0]]) is the winner!"
//                resultLabel.text = "\(currentPlayer) is the winner!"
                replayButton.isHidden = false
                if (game[win[0]] == "X") {
                    myScore += 1
                    myScoreLabel.text = "You: \(myScore)"
                } else {
                    aiScore += 1
                    aiScoreLabel.text = "AI: \(aiScore)"
                }
                return currentPlayer
            }
        }
        
        //check tie
        if !game.contains("") {
            gameOver = true
            resultLabel.text = "It's a tie!"
            replayButton.isHidden = false
            return nil
        }
        
        //else no winner yet
        return nil
    }
    
    @IBAction private func resetGame() {
        for num in 0...8 {
            game[num] = ""
            buttons[num].setTitle("", for: .normal)
        }
        gameOver = false
        resultLabel.text = " "
        replayButton.isHidden = true
        startGame()
    }
    
}

enum Player: String {
    case X = "X"
    case O = "O"
    
    func firstPlayer() -> Player {
        return arc4random_uniform(2) == 0 ? .X : .O
    }
    
    func switchPlayer() -> Player {
        return (self == .X) ? .O : .X
    }
}
