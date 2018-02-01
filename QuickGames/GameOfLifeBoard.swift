//
//  GameOfLifeBoard.swift
//  GameOfLife
//
//  Created by Lily Song on 2018-01-24.
//  Copyright © 2018 Lily Song. All rights reserved.
//

import UIKit

@IBDesignable
class GameOfLifeBoard: UIView {

    let aliveColor: UIColor = UIColor.lightGray
    let deadColor: UIColor = UIColor.white
    
    var filledPieces: [(UIColor, Int, Int)] = [(UIColor, Int, Int)]()
    var cells: [[Int]] = Array(repeating: Array(repeating: 1, count: 100), count: 100)
    
    private func drawRect(_ column: Int, _ row: Int) {
        let squareWidth = Int((bounds.width - 30) / 100)
        UIBezierPath(rect: CGRect(x: column*squareWidth, y: row*squareWidth, width: squareWidth, height: squareWidth)).fill()
    }
    func placePiece(for color: UIColor, at coordinates: (column: Int, row: Int)) {
        color.set()
        filledPieces.append((color, coordinates.column, coordinates.row))
        self.setNeedsDisplay()
    }
    
    private func isAlive(_ column: Int, _ row: Int) -> Bool {
        aliveColor.set()
        return cells[row][column] == 1
    }
    
    private func isDead(_ column: Int, _ row: Int) -> Bool {
        deadColor.set()
        return cells[row][column] == 0
    }
    
    override func draw(_ rect: CGRect) {
        cells[0][0] = 0
        cells[0][1] = 0
        cells[5][5] = 0
        for column in 0...99 { for row in 0...99 {
            if (isAlive(column, row))
            {
                drawRect(column, row)
            }
        }}
    }
}
