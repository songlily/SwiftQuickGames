//
//  TicTacToeView.swift
//  QuickGames
//
//  Created by Lily Song on 2017-12-15.
//  Copyright © 2017 Lily Song. All rights reserved.
//

import UIKit

@IBDesignable
class TicTacToeView: UIView {
    //draws grid
    
    var lineWidth: CGFloat = 7.0
    var color: UIColor = UIColor.darkGray
    
    private enum GridLine {
        case left
        case right
        case top
        case bottom
    }
    private func pathForGrid(_ gridLine: GridLine) -> UIBezierPath {
        let line = UIBezierPath()
        line.lineWidth = lineWidth
        
        switch gridLine  {
        case .left:
            line.move(to: CGPoint(x: (bounds.width / 3), y: 0))
            line.addLine(to: CGPoint(x: (bounds.width / 3), y: bounds.height))
        case .right:
            line.move(to: CGPoint(x: (bounds.width * 2 / 3), y: 0))
            line.addLine(to: CGPoint(x: (bounds.width * 2 / 3), y: bounds.height))
        case .top:
            line.move(to: CGPoint(x: 0, y: (bounds.height / 3)))
            line.addLine(to: CGPoint(x: bounds.width, y: (bounds.height / 3)))
        case .bottom:
            line.move(to: CGPoint(x: 0, y: (bounds.height * 2 / 3)))
            line.addLine(to: CGPoint(x: bounds.width, y: (bounds.height * 2 / 3)))
        }
        
        return line //UIBezierPath()
    }
    
    
    override func draw(_ rect: CGRect) {
        color.set()
        
        pathForGrid(.left).stroke()
        pathForGrid(.right).stroke()
        pathForGrid(.top).stroke()
        pathForGrid(.bottom).stroke()
    }
 

}
