//
//  ScoreTracker.swift
//  ScriptedWumpusWorld
//
//  Created by Philipp Brendel on 15.08.16.
//  Copyright © 2016 Entenwolf Software. All rights reserved.
//

import Foundation

class ScoreTracker {
    
    fileprivate var actionCount = 0
    fileprivate var dead = false,
        gold = false,
        hasArrow = true,
        wumpusAlive = true
    
    func actionPerformed() {
        actionCount += 1
    }
    
    func hasDied() {
        dead = true
    }
    
    func gotGold() {
        gold = true
    }
    
    func shotArrow() {
        hasArrow = false
    }
    
    func killedWumpus() {
        wumpusAlive = false
    }
    
    var text: String {
        var s = "You took \(actionCount) turns."
        
        if !hasArrow {
            s.append("You used the arrow. ")
        }
        
        if !wumpusAlive {
            s.append("You killed the wumpus. ")
        }
        
        if gold {
            s.append("You found the gold. ")
        }
        
        if dead {
            s.append("You died. ")
        }
        
        return s
        
    }
    
    var score: Int {
        let s =
            0
            - actionCount
            - ((!hasArrow && wumpusAlive) ? 15 : 0)
            - (dead ? 80 : 0)
            + (gold ? 100 : 0)
        
        return max(s, 0)
    }
}

































