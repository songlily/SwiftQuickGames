//
//  ViewController.swift
//  GameOfLife
//
//  Created by Lily Song on 2018-01-24.
//  Copyright © 2018 Lily Song. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var board: GameOfLifeBoard!  { didSet{ board.setNeedsDisplay() } }
    var gameTimer: Timer!

    let neighbours: [[Int]] = [
        [-1, -1], [-1, 0], [-1, +1],
        [0, -1], [0, +1],
        [+1, -1], [+1, 0], [+1, +1]
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        playGame()
    }
    
    private func countNeighbours(for row: Int, _ column: Int) -> Int {
        var count = 0
        for neighbour in neighbours {
            if board.cells[row + neighbour[0]][column + neighbour[1]] == 1 {
                count += 1
            }
        }
        return count
    }
    
    private func playGame() {
        // start game
        for column in 0...99 {
            for row in 0...99 {
                board.cells[row][column] = Int(arc4random_uniform(2))
            }
        }
        
        // run game
        gameTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) {weak in
            for column in 0...99 {
                for row in 0...99 {
                    let count = self.countNeighbours(for: row, column)
                    if (count == 2 || count == 3) {
                        self.board.cells[row][column] = 1
                    } else {
                        self.board.cells[row][column] = 0
                    }
                }
            }
        }

    }

}

