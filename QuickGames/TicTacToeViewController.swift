//
//  TicTacToeViewController.swift
//  QuickGames
//
//  Created by Lily Song on 2017-12-15.
//  Copyright © 2017 Lily Song. All rights reserved.
//

import UIKit

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

class TicTacToeViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!      //auto sorted by tags 1-9
    private var game = ["", "", "",
                        "", "", "",
                        "", "", ""]     {
        didSet {
            //every time game changes, check for winner and gameover; switch players if no winner
            if checkForWinner() == nil && !gameOver {
                currentPlayer = currentPlayer.switchPlayer()
                if currentPlayer == .O {
                    aiMakeMove()
                }
            }
        }
    }
    
    //     buttons tags = [1, 2, 3,      game = [0, 1, 2,
    //                     4, 5, 6,              3, 4, 5,
    //                     7, 8, 9]              6, 7, 8]

    // I chose to +1 to the button tags because by default all the tags are 0
    // I accomodate for this offset only in makeMove
    
    private let wins = [[0, 1, 2], [3, 4, 5], [6, 7, 8],          //rows
                        [0, 3, 6], [1, 4, 7], [2, 5, 8],          //columns
                        [0, 4, 8], [2, 4, 6]]                     //diagonals

    var currentPlayer: Player = .X  //only for initialization
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
    }
    
    private func startGame() {
        currentPlayer = currentPlayer.firstPlayer()     //randomize first player
        if currentPlayer == .O {                        //if first player is computer, play
            aiMakeMove()
        }
    }
    
    private func setGameCell(at index: Int, with move: String) {
        buttons[index].setTitle(move, for: .normal)     //change button
        game[index] = move                              //record change in game
    }
    
    @IBAction private func makeMove(_ sender: UIButton) {
        let spot = sender.tag - 1           //subtract one to accomodate the diff btwn game and buttons
        guard (game[spot] == "" && !gameOver) else { return }
        
        setGameCell(at: spot, with: currentPlayer.rawValue)
    }
    
    private func twoInARow (for letter: String) -> Bool {
        //makes a move if two in a row
        for win in wins {
            if     (game[win[0]] == game[win[1]] && game[win[0]] == letter)
                || (game[win[0]] == game[win[2]] && game[win[0]] == letter)
                || (game[win[1]] == game[win[2]] && game[win[1]] == letter) {
                for num in 0...2 {
                    let spot = win[num]
                    if game[spot] == "" {
                        setGameCell(at: spot, with: currentPlayer.rawValue)
                        return true
                    }
                }
            }
        }
        return false
    }
    
    private func aiMakeMove() {
        if twoInARow(for: "O") || twoInARow(for: "X") {     //win or block human's win, if two in a row
            return
        }
        
        var spot: Int               //else random move
        repeat {
            spot = Int(arc4random_uniform(9))
        } while (game[spot] != "")
        
        setGameCell(at: spot, with: currentPlayer.rawValue)
    }
    
    private func checkForWinner() -> Player? {
        guard !gameOver else { return nil }
        
        //check for win
        for win in wins {
            if game[win[0]] != "",
               game[win[0]] == game[win[1]],
               game[win[1]] == game[win[2]] {
                gameOver = true
                resultLabel.text = "\(currentPlayer) is the winner!"
                replayButton.isHidden = false
                if (currentPlayer == .X) {
                    myScore += 1
                    myScoreLabel.text = "You: \(myScore)"
                } else {
                    aiScore += 1
                    aiScoreLabel.text = "AI: \(aiScore)"
                }
                return currentPlayer
            }
        }
        
        //check for tie
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
        for spot in 0...8 {
            setGameCell(at: spot, with: "")
        }
        gameOver = false
        resultLabel.text = " "
        replayButton.isHidden = true
        startGame()
    }
}
