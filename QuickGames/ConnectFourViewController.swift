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
}

class ConnectFourViewController: UIViewController {
    
    //array nums: 0-6, 7-13, 14-20, 21-27, 28-34, 35-41
    private var game: [String] = Array(repeating: "", count: 42)

    // TO TRY: maybe play w 2D array instead?
    // private var game: [[String]] = Array(repeating: Array(repeating: "", count: 7), count: 6)
    
    //private var board = ConnectFourBoard()
    @IBOutlet weak var board: ConnectFourBoard! {didSet{ board.setNeedsDisplay() }}
    
    @IBOutlet var columns: [UIButton]!
    
    var currentPlayer: Player = .human
    var gameOver = false
    
    @IBOutlet weak var gameResultLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //startGame()
    }

    private func startGame() {
        currentPlayer = currentPlayer.firstPlayer()     //randomize first player
        if currentPlayer == .ai {                        //if first player is computer, play
            aiMakeMove()
        }
    }
    
    private func setGameCell(for column: Int) {
        // given a column in game
        // checks from bottom which row is blank
        // places piece at column, (blank) row
        
        var row = 5
        repeat {
            let spot = (column)+(row*7)
            if game[spot] == "" {
                game[spot] = currentPlayer.TTTplay             //TO DO: change later
                board.placePiece(for: currentPlayer.CFcolor, at: (column, row))
                return
            }
            row -= 1
        } while (row >= 0)
    }
    
    private func checkColumnFull(_ column: Int) -> Bool {
        var full = true
        for row in 0...5 {
            if game[(column)+(row*7)] == "" {
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
        // play for win, if any
        // block human win, if any
        // check if play will result in human win?
        // how far can I plan ahead?
    }
    
    private func checkForWinner() -> Player? {
        // win if four in a row
            //check rows, columns
            //check diagonals
        
        // tie if board is full
        if !game.contains("") {
            gameOver = true
            gameResultLabel.text = "Tie!"
        }
        return nil
    }
    
    private func resetGame() {
        // reset/clear all variables
        // (re)start game
        for spot in 0...34 {
            game[spot] = ""
        }
        gameOver = false
        startGame()
    }
    
}
