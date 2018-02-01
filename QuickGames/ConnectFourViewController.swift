//
//  ConnectFourViewController.swift
//  QuickGames
//
//  Created by Lily Song on 2018-01-01.
//  Copyright © 2018 Lily Song. All rights reserved.
//

import UIKit

extension Player {
    var CFcolor: UIColor {
        return (self == .human) ? UIColor.red : UIColor.black
    }
    
    static func CFwinner(_ play: String) -> Player {
        return (play == "X") ? .human : .ai
    }
    
    var winner: String {
        return (self == .human) ? "You win!" : "Computer wins!"
    }
}

enum Direction {
    // column, row, diagonal left, diagonal right
    case column
    case row
    case diagLeft
    case diagRight
    
    func nextSpot (column: Int, row: Int, offset: Int) -> Int {
        switch self {
        case .column:
            return getIndex(column: column, row: row + offset)
        case .row:
            return getIndex(column: column + offset, row: row)
        case.diagLeft:
            return getIndex(column: column, row: row) + (offset * 8)
        case .diagRight:
            return getIndex(column: column, row: row) + (offset * 6)
        }
    }
    func getIndex (column: Int, row: Int) -> Int {                          //TO DO: change later; repetitive
        return column + (row * 7)
    }
}

class ConnectFourViewController: UIViewController {
    
    //array nums: 0-6, 7-13, 14-20, 21-27, 28-34, 35-41
    private var game: [String] = Array(repeating: "", count: 42) {
        didSet {
            if checkForWinner() == nil && !gameOver {
                currentPlayer = currentPlayer.switchPlayer()
                if currentPlayer == .ai {
                    aiMakeMove()
                }
            }
        }
    }

    // TO TRY: maybe play w 2D array instead?
    // private var game: [[String]] = Array(repeating: Array(repeating: "", count: 7), count: 6)
    
    //private var board = ConnectFourBoard()
    @IBOutlet weak var board: ConnectFourBoard! { didSet{ board.setNeedsDisplay() } } //setNeedsDisplay here??
    
    @IBOutlet var columns: [UIButton]!
    @IBOutlet weak var replayButton: UIButton!
    
    @IBOutlet weak var myScoreLabel: UILabel!
    @IBOutlet weak var aiScoreLabel: UILabel!
    private var myScore = 0
    private var aiScore = 0
    
    var currentPlayer: Player = .human
    var gameOver = false
//    private weak var aiPlayDelay: Timer?
    
    @IBOutlet weak var gameResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
    }

    private func startGame() {
        currentPlayer = currentPlayer.firstPlayer()     //randomize first player
        if currentPlayer == .ai {                        //if first player is computer, play
            aiMakeMove()
        }
    }
    
    private func setGameCell(for column: Int) {
        var row = 5
        repeat {
            let spot = getIndex(column: column, row: row)
            if game[spot] == "" {
                board.placePiece(for: currentPlayer.CFcolor, at: (column, row))
                game[spot] = currentPlayer.TTTplay             //TO DO: change later
                return
            }
            row -= 1
        } while (row >= 0)
    }
    
    private func checkColumnFull(_ column: Int) -> Bool {
        var full = true
        for row in 0...5 {
            let spot = getIndex(column: column, row: row)
            if game[spot] == "" {
                full = false
                return full
            }
        }
        return full
    }
    
    @IBAction func makeMove(_ sender: UIButton) {
        let column = sender.tag - 1                     // takes column of tap
        let full = checkColumnFull(column)
        
        guard (!full && !gameOver) else { return }
        setGameCell(for: column)                        // sets game cell
    }
    
    private func aiMakeMove() {
        var column: Int
        var full: Bool
        repeat {
            column = Int(arc4random_uniform(7))
            full = checkColumnFull(column)
        } while (full)

        guard (!full && !gameOver) else { return }
        setGameCell(for: column)                        // sets game cell
        
        // if game empty, play middle column (3)
        // recursively find all possible solutions
        // use minimax? -> look to max own score & assume human will play min move but adapt if human is dumb

//        if !game.contains("X") && !game.contains("O") {         //if game is empty/first player
//            setGameCell(for: 3)
//            return
//        }
        
        //let column = minimax()
        //setGameCell(for: column)
        
    }
    
    func minimax() {
        
        //take emptySpots and explore options w minimax
        //return column to play

        var emptySpots = [Int]()
        for num in 0...41 {
            if game[num] == "" {
                emptySpots.append(num)
            }
        }
        
        var possibleGame = game
        for spot in emptySpots {
            possibleGame[spot] = currentPlayer.TTTplay
            //add +10 if possible win -> checkForWinner()
        }
        
        //get column for spot
        //return column (Int)
    }
    
    func getIndex (column: Int, row: Int) -> Int {
        return column + (row * 7)
    }
    
    private func setWinner() {
        gameResultLabel.text = currentPlayer.winner
        //            (currentPlayer == .human) ? (myScore += 1) : (aiScore += 1)
        //            myScoreLabel.text = "You: \(myScore)"
        //            aiScoreLabel.text = "AI: \(aiScore)"
        if (currentPlayer == .human) {
            myScore += 1
            myScoreLabel.text = "You: \(myScore)"
        } else {
            aiScore += 1
            aiScoreLabel.text = "AI: \(aiScore)"
        }
        gameOver = true
        replayButton.isHidden = false
        //return tuple?? Player.CFwinner(game[getIndex(column: column, row: row)])
    }
    
    private func fourIn(a direction: Direction, at column: Int, _ row: Int) -> Bool {
        var count = 0
        let firstSpot = getIndex(column: column, row: row)
        let player = game[firstSpot]
        
        guard (player != "") else { return false }
        for offset in 1...3 {
            let spot = direction.nextSpot(column: column, row: row, offset: offset)
            if game[spot] == player {
                count += 1
            }
        }
        if count == 3 {
            setWinner()
            return true
        }
        
        return false
    }
    
    private func checkForWinner() -> Player? {
        guard (!gameOver) else { return nil }
        // TO TRY: return tuple (winning player (if any), gameOver)
        //array nums: 0-6, 7-13, 14-20, 21-27, 28-34, 35-41
        
        // don't check 4 times, guard against checking once returned
        
        //check for 4 in a column
        for column in 0...6 {
            for row in 0...2 {
                if fourIn(a: .column, at: column, row) {
                    return Player.CFwinner(game[getIndex(column: column, row: row)])
                }
            }
        }
        //check for 4 in a row
        for row in 0...5 {
            for column in 0...3 {
                if fourIn(a: .row, at: column, row) {
                    return Player.CFwinner(game[getIndex(column: column, row: row)])
                }
            }
        }
        //check for 4 in diagonals first 4x3, last 4x3
        for column in 0...3 {
            for row in 0...2 {
                if fourIn(a: .diagLeft, at: column, row) {
                    return Player.CFwinner(game[getIndex(column: column, row: row)])
                }
            }
        }
        for column in 3...6 {
            for row in 0...2 {
                if fourIn(a: .diagRight, at: column, row) {
                    return Player.CFwinner(game[getIndex(column: column, row: row)])
                }
            }
        }
        
        // tie if board is full
        if (!game.contains("") && !gameOver) {
            gameOver = true
            gameResultLabel.text = "Tie!"
            replayButton.isHidden = false
        }
        return nil
    }
    
    @IBAction private func resetGame() {
        board.filledPieces.removeAll()
        board.setNeedsDisplay()
        for spot in 0...41 {
            game[spot] = ""
        }
        gameOver = false
        gameResultLabel.text = ""
        replayButton.isHidden = true
        
        startGame()
    }
    
}




//        var column: Int
//        var full: Bool
//        repeat {
//            column = Int(arc4random_uniform(7))
//            full = checkColumnFull(column)
//        } while (full)
//
//        guard (!full && !gameOver) else { return }
//        setGameCell(for: column)                        // sets game cell

//TO LEARN: alpha-beta pruning/minimax?
// play for win, if any
// block human win, if any



//        for column in 0...6 {
//            for row in 0...5 {
//                if threeIn(a: .column, at: column, row) {
//                    guard (!checkColumnFull(column)) else { return }
//                    // guard column full/fourth spot empty
//                    // take player at (column, row)
//                    // prioritize ai player?
//                }
//
//            }
//        }
//        var played = false
//        //check for 3 in a row/column/diagonal
//        let column = 0
//        for row in 3...5 {
//            let bottomSpot = getIndex(column: column, row: row)
//
//            guard (game[bottomSpot] != "") else { continue }
//            let upperSpot1 = getIndex(column: column, row: row-1)
//            let upperSpot2 = getIndex(column: column, row: row-2)
//            if (game[bottomSpot] == game[upperSpot1]) && (game[bottomSpot] == game[upperSpot2]) {
//                let upperSpot3 = getIndex(column: column, row: row-3)
//                if (game[upperSpot3] == "") {
//                    setGameCell(for: column)
//                    played = true
//                }
//            }
//        }
//
//        if !played {
//            let col = 0
//            setGameCell(for: col)
//        }


// check if play will allow human win?
// how far can I plan ahead?
// tree-like format?? INVESTIGATE: alpha beta pruning, minimax algorithm, monte carlo tree search

// prefer centre over corners over edges?
// or else random
