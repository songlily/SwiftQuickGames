//
//  TicTacToeViewController.swift
//  QuickGames
//
//  Created by Lily Song on 2017-12-09.
//  Copyright © 2017 Lily Song. All rights reserved.
//

import UIKit

class TicTacToeViewController: UIViewController {
    
    private let wins = [(0, 1, 2), (3, 4, 5), (6, 7, 8),
                        (0, 3, 6), (1, 4, 7), (2, 5, 8),
                        (0, 4, 8), (2, 4, 6)]
    //                        (1, 2, 3), (4, 5, 6), (7, 8, 9),    //rows
    //                        (1, 4, 7), (2, 5, 8), (3, 6, 9),    //columns
    //                        (1, 5, 9), (3, 5, 7)]               //diagonals
    private var game = ["", "", "",
                        "", "", "",
                        "", "", ""] //    { didSet {  } }
    //     buttons = [1, 2, 3,
    //                4, 5, 6,
    //                7, 8, 9]


    
    var currentPlayer: Player = .X //: Player!
    var gameOver = false
    
    @IBOutlet weak var tttView: TicTacToeView!
    @IBOutlet weak var resultLabel: UILabel!
    @IBOutlet weak var replayButton: UIButton!
    @IBOutlet weak var myScoreLabel: UILabel!
    @IBOutlet weak var aiScoreLabel: UILabel!
    var myScore = 0
    var aiScore = 0

    
    @IBOutlet var buttons: [UIButton]!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
        replayButton.isHidden = true
    }
    
    func startGame() {
        currentPlayer = currentPlayer.firstPlayer()
        if currentPlayer == .O {
            aiMakeMove()
            currentPlayer = currentPlayer.switchPlayer()
        }
    }
    
    @IBAction func makeMove(_ sender: UIButton) {
        let play = sender.tag - 1
        guard (game[play] == "" && !gameOver) else { return }
        
        game[play] = "X"                    //record in game
        sender.setTitle("X", for: .normal)   //change button
        
//        game[play] = currentPlayer.rawValue                     //record in game
//        sender.setTitle(currentPlayer.rawValue, for: .normal)   //change button
        
        if checkForWinner() == nil && !gameOver {
            currentPlayer = currentPlayer.switchPlayer()
            aiMakeMove()
        }
        
    }
    
    func aiMakeMove() {
        var played = false
        
        //make winning move if any
        for win in wins {
            if !played {
                if     (game[win.0] == game[win.1] && game[win.0] == "O")
                    || (game[win.0] == game[win.2] && game[win.0] == "O")
                    || (game[win.1] == game[win.2] && game[win.1] == "O") {
            //iterate through tuple?    //for num in 0...2; game[win.num]
            //very repetitive
                    if game[win.0] == "" {
                        game[win.0] = "O"
                        for int in 0...8 {
                            if buttons[int].tag == (win.0 + 1) {
                                buttons[int].setTitle("O", for: .normal)
                            }
                        }
                        played = true
                    }
                    if game[win.1] == "" {
                        game[win.1] = "O"
                        for int in 0...8 {
                            if buttons[int].tag == (win.1 + 1) {
                                buttons[int].setTitle("O", for: .normal)
                            }
                        }
                        played = true
                    }
                    if game[win.2] == "" {
                        game[win.2] = "O"
                        for int in 0...8 {
                            if buttons[int].tag == (win.2 + 1) {
                                buttons[int].setTitle("O", for: .normal)
                            }
                        }
                        played = true
                    }
                }
            }
        }
        
        //block human's winning move if any
        for win in wins {
            if !played{
                if ((game[win.0] == game[win.1] || game[win.0] == game[win.2]) && game[win.0] == "X")
                    || (game[win.1] == game[win.2] && game[win.1] == "X") {
                    if game[win.0] == "" {
                //iterate through tuple?
                        game[win.0] = "O"
                        for int in 0...8 {
                            if buttons[int].tag == (win.0 + 1) {
                                buttons[int].setTitle("O", for: .normal)
                            }
                        }
                        played = true
                    }
                    if game[win.1] == "" {
                        game[win.1] = "O"
                        for int in 0...8 {
                            if buttons[int].tag == (win.1 + 1) {
                                buttons[int].setTitle("O", for: .normal)
                            }
                        }
                        played = true
                    }
                    if game[win.2] == "" {
                        game[win.2] = "O"
                        for int in 0...8 {
                            if buttons[int].tag == (win.2 + 1) {
                                buttons[int].setTitle("O", for: .normal)
                            }
                        }
                        played = true
                    }
                }
                
            }
        }
        
        //else best move/random
        if !played {
            
            //if empty around spot, fill
            
            var num = Int(arc4random_uniform(9))
            
            if game[num] != "" {
                repeat { num = Int(arc4random_uniform(9)) }
                    while (game[num] != "")
            }
            
            game[num] = "O"
            for int in 0...8 {
                if buttons[int].tag == (num + 1) {
                    buttons[int].setTitle("O", for: .normal)
                    played = true
                }
            }
            
            
//            repeat { let num = Int(arc4random_uniform(9)) } while (game[num] != "")
//
//            if game[num] == "" {
//                game[num] = "O"
//                for int in 0...8 {
//                    if buttons[int].tag == num {
//                        buttons[int].setTitle("O", for: .normal)
//                        played = true
//                    }
//                }
////                    buttons[num].setTitle(currentPlayer.rawValue, for: .normal)
//            }
        }
        
        if checkForWinner() == nil && !gameOver {
            currentPlayer = currentPlayer.switchPlayer()
        }
    }
    
    
    
    func checkForWinner() -> Player? {
        //check win
        for win in wins {
            if game[win.0] != "",
                game[win.0] == game[win.1],
                game[win.1] == game[win.2] {
                resultLabel.text = "\(game[win.0]) is the winner!"
                gameOver = true
                replayButton.isHidden = false
                if (game[win.0] == "X") {
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
            resultLabel.text = "It's a tie!"
            gameOver = true
            replayButton.isHidden = false
            return nil
        }
        
        //else
        return nil
    }
    
    @IBAction func resetGame() {
        for num in 0...8 {
            game[num] = ""
        }
        for num in 0...8 {
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
