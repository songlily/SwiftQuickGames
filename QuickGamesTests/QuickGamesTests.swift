//
//  QuickGamesTests.swift
//  QuickGamesTests
//
//  Created by Lily Song on 2018-01-12.
//  Copyright © 2018 Lily Song. All rights reserved.
//

import XCTest
@testable import QuickGames

class QuickGamesTests: XCTestCase {
    
    var TTTvc: TicTacToeViewController!
    
    let gameState1 = ["O", "", "",              //ai win
                      "", "O", "",
                      "", "", "O"]
    let gameState2 = ["X", "", "",              //human win
                      "", "X", "",
                      "", "", "X"]
    let gameState3 = ["X", "O", "X",            //tie
                      "X", "X", "O",
                      "O", "X", "O"]
    let gameState4 = ["", "", "",               //not complete
                      "", "", "",
                      "", "", ""]
    
    
    override func setUp() {
        super.setUp()
        
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        TTTvc = storyboard.instantiateInitialViewController() as! TicTacToeViewController
    }
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testCheckWinner() {
        XCTAssert(TTTvc.checkWinner(for: gameState1).0 == Player.ai)
        XCTAssert(TTTvc.checkWinner(for: gameState2).0 == Player.human)
        XCTAssert(TTTvc.checkWinner(for: gameState3).0 == nil)
        XCTAssert(TTTvc.checkWinner(for: gameState4).0 == nil)
    }
    
    func testCheckScore() {
        XCTAssert(TTTvc.checkScore(for: gameState1, at: 0) == 10)
        XCTAssert(TTTvc.checkScore(for: gameState2, at: 0) == -10)
        XCTAssert(TTTvc.checkScore(for: gameState3, at: 0) == 0)
        XCTAssert(TTTvc.checkScore(for: gameState4, at: 0) == nil)
    }
    
    func testMinimax() {
        XCTAssert(TTTvc.minimax(for: gameState3, with: Player.ai, at: 0) == 0)
        
        let gameState = ["O", "O", "",               //not complete
                         "", "X", "",
                         "X", "", ""]
        XCTAssert(TTTvc.minimax(for: gameState, with: Player.ai, at: 0) == 2)
    }
}
