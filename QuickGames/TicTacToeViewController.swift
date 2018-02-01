//
//  TicTacToeViewController.swift
//  QuickGames
//
//  Created by Lily Song on 2017-12-15.
//  Copyright © 2017 Lily Song. All rights reserved.
//

import UIKit
//import QuickGamesTests

enum Player {
    case human
    case ai
    
    var TTTplay: String {
        switch self {
        case .human: return "X"
        case .ai: return "O"
        }
    }
    
    func firstPlayer() -> Player {
        return arc4random_uniform(2) == 0 ? .human : .ai
    }
    
    func switchPlayer() -> Player {
        return (self == .human) ? .ai : .human
    }
}

class TicTacToeViewController: UIViewController {
    
    @IBOutlet var buttons: [UIButton]!      //auto sorted by tags 1-9
    private var game = ["", "", "",
                        "", "", "",
                        "", "", ""]     {
        didSet {
            if checkForWinner() == nil && !gameOver {
                currentPlayer = currentPlayer.switchPlayer()
                if currentPlayer == .ai {
                    aiMakeMove(for: game)
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

    var currentPlayer: Player = .human  //only for initialization
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
        if currentPlayer == .ai {                        //if first player is computer, play
            aiMakeMove(for: game)
        }
    }
    
    private func setGameCell(at index: Int, with move: String) {
        buttons[index].setTitle(move, for: .normal)     //change button
        game[index] = move                              //record change in game
    }
    
    @IBAction private func makeMove(_ sender: UIButton) {
        let spot = sender.tag - 1           //subtract one to accomodate the diff btwn game and buttons
        guard (game[spot] == "" && !gameOver) else { return }
        
        setGameCell(at: spot, with: currentPlayer.TTTplay)
    }
    
    // MINIMAX FUNCTIONS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    func checkWinner(for gameState: [String]) -> (player: Player?, gameOver: Bool) {
        // takes game
        // checks for winner and gameOver; returns
        //check for win
        for win in wins {
            if gameState[win[0]] != "",
                gameState[win[0]] == gameState[win[1]],
                gameState[win[1]] == gameState[win[2]] {
                if gameState[win[0]] == "X" {
                    return (.human, true)
                } else {
                    return (.ai, true)
                }
            }
        }
        
        //check for tie
        if !gameState.contains("") {
            return (nil, true)
        }
        //else no winner yet
        return (nil, false)
    }
    
    func checkScore(for gameState: [String], at depth: Int) -> Int? {
        // given gameState
        // check for winner and return score? based on result
        if checkWinner(for: gameState).player == .ai {
            return 10 - depth
        }
        else if checkWinner(for: gameState).player == .human {
            return depth - 10
        }
        else if !gameState.contains(""){
            return 0
        }
        else { return nil }
    }
    
    func getNewState (for gameState: [String], at move: Int, with activePlayer: Player) -> [String] {
        // given a gamestate, move, and player
        // set new state at move with player
        // return game
        var possibleGame = gameState
        possibleGame[move] = activePlayer.TTTplay
        return possibleGame
    }
    
    var depth = 0           //use depth to pick shortest route to victory
    
    func minimax (for gameState: [String], with activePlayer: Player, at depth: Int) -> Int {
//        guard (!gameState.contains("")) else { return checkScore(for: gameState) }   //returns 0 if no empty spots
//        what does minimax return? how return tie?
        guard (checkWinner(for: gameState).gameOver != true) else { return 0 }
        
        var scores = [Int]()
        var possibleGame = [String]()
        let moves = zip(Array(0...8), gameState).filter{$0.1 == ""}.map{$0.0}   //array of empty spots
        // guard moves not empty
        for move in moves {
            possibleGame = getNewState(for: gameState, at: move, with: activePlayer)
            
            let score = checkScore(for: possibleGame, at: depth)
            if score != nil {
                scores.append(score!)
            } else {
                scores.append(minimax(for: possibleGame, with: activePlayer.switchPlayer(), at: depth + 1))
            }
        }
        
        if depth == 0 {         // if first level, return index
            return scores.index(where: {$0 == scores.max()})!       //return spot
        } else
        if activePlayer == .ai {
            return scores.max()!
        } else {
            return scores.min()!
        }
        
        // need *index of spot *append value of spot
        
        // guard game has no empty spots else checkScore (return 0)
        // given a gamestate and player
        // check for empty moves in game
        // for each move in moves
            // get new state at move with player
        // if checkScore for possible game isn't nil, add score to score array
        // else if nil (game not iver), call minimax on possibleGameState for other player
        
        // if player is computer, return max score in scores
        // else if player is human, return min score in scores
        
        
//        guard (!checkWinner(for: gameState).1) else { return checkScore(for: gameState)! }
        
//        var scores = [Int]()
//        var possibleGame = [String]()
//        let moves = zip(Array(0...8), gameState).filter{$0.1 == ""}.map{$0.0}   //array of empty spots
//
//        for move in moves {                                             //for spot in empty spots
//            possibleGame = getNewState(for: gameState, at: move, with: activePlayer)            //tries to play move in state
//            if checkScore(for: possibleGame) != nil {
//                scores.append(checkScore(for: possibleGame)!)
//            }
//            else {
//                depth += 1
//                scores.append(minimax(for: possibleGame, with: activePlayer.switchPlayer()).1)
//            }
//        }
//
//        if activePlayer == .ai {               //check
//            //return index of max score in scores
//            if let max = scores.index(where: {$0 == scores.max()}) {
//                return (max, scores.max()!)  //max spot, max score
//            }
//        } else {
//            //return index of min score in scores
//            if let min = scores.index(where: {$0 == scores.min()}) {
//                return (min, scores.min()!)  //min spot, min score
//            }
//        }
//        return (0, 0)
    }
    
    func aiMakeMove(for games: [String]) {
        // if first play, play random corner
        if !game.contains("X") && !game.contains("O") {
            let corners = [0, 2, 6, 8]
            setGameCell(at: corners[Int(arc4random_uniform(4))], with: currentPlayer.TTTplay)
            return
        }
        
        let depth = 0
        let activeTurn = currentPlayer
        let play = minimax(for: games, with: activeTurn, at: depth)
        guard (game[play] != "") else { return }
        setGameCell(at: play, with: currentPlayer.TTTplay)
    }
        
//        if twoInARow(for: "O") || twoInARow(for: "X") {     //win or block human's win, if two in a row
//            return
//        }
//
//        var spot: Int               //else random move
//        repeat {
//            spot = Int(arc4random_uniform(9))
//        } while (game[spot] != "")
//
//        setGameCell(at: spot, with: currentPlayer.TTTplay)
//
//
//    private func twoInARow (for letter: String) -> Bool {
//        //makes a move if two in a row
//        for win in wins {
//            if     (game[win[0]] == game[win[1]] && game[win[0]] == letter)
//                || (game[win[0]] == game[win[2]] && game[win[0]] == letter)
//                || (game[win[1]] == game[win[2]] && game[win[1]] == letter) {
//                for num in 0...2 {
//                    let spot = win[num]
//                    if game[spot] == "" {
//                        setGameCell(at: spot, with: currentPlayer.TTTplay)
//                        return true
//                    }
//                }
//            }
//        }
//        return false
//    }
    
    // MINIMAX FUNCTIONS~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    
    private func checkForWinner() -> Player? {
        guard !gameOver else { return nil }
        
        //check for win
        for win in wins {
            if game[win[0]] != "",
               game[win[0]] == game[win[1]],
               game[win[1]] == game[win[2]] {
                gameOver = true
                resultLabel.text = "\(currentPlayer.TTTplay) is the winner!"
                replayButton.isHidden = false
                if (currentPlayer == .human) {
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
