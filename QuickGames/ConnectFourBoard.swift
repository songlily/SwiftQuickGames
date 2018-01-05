//
//  ConnectFourBoard.swift
//  QuickGames
//
//  Created by Lily Song on 2018-01-01.
//  Copyright © 2018 Lily Song. All rights reserved.
//

import UIKit

@IBDesignable
class ConnectFourBoard: UIView {

    //seven columns six rows
    let boardColor: UIColor = UIColor.lightGray
    let blankColor: UIColor = UIColor.white
    
    var filledPieces: [(UIColor, Int, Int)] = [(UIColor, Int, Int)]()
    
    private func drawBoard() {
        boardColor.set()
        let board = UIBezierPath(rect: CGRect(x:        15,
                                              y:        15,
                                              width:    (bounds.width - 30),
                                              height:   (bounds.width - 30) * 6/7))
        board.fill()
    }
    
    private func drawCircle(at column: Int, _ row: Int) {
        let squareWidth = (bounds.width - 30) / 7
        
        let centre = CGPoint(x: (CGFloat(column) * squareWidth) + squareWidth/2 + 15,
                             y: (CGFloat(row) * squareWidth) + squareWidth/2 + 15)
        let circle = UIBezierPath(arcCenter: centre,
                                  radius: (squareWidth/2) - 5,
                                  startAngle: 0,
                                  endAngle: 2 * CGFloat.pi,
                                  clockwise: false)
        circle.fill()
    }
    private func drawBlankPieces() {
        blankColor.set()
        
        // 7 rows, 6 columns
        for column in 0...6 {
            for row in 0...5 {                      
                drawCircle(at: column, row)
            }
        }
    }
    
    func placePiece(for color: UIColor, at coordinates: (column: Int, row: Int)) {
        color.set()
        print("PIECE PLACED AT \(coordinates)")
        
        //drawCircle(at: coordinates.column, coordinates.row)
        filledPieces.append((color, coordinates.column, coordinates.row))
        self.setNeedsDisplay()
    }
    
    
    override func draw(_ rect: CGRect) {
        drawBoard()
        drawBlankPieces()
        for element in filledPieces {
            element.0.set()
            drawCircle(at: element.1, element.2)
        }
    }

}
