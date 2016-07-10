//
//  GameScene(Sensations).swift
//  ScriptedWumpusWorld
//
//  Created by Philipp Brendel on 12.09.16.
//  Copyright © 2016 Entenwolf Software. All rights reserved.
//

import Foundation

extension GameScene {
    func feelBreeze(_ position: CGPoint) -> Bool {
        let possiblePitPositions = [
            CGPoint(x: position.x - tileSize.width, y: position.y),
            CGPoint(x: position.x + tileSize.width, y: position.y),
            CGPoint(x: position.x, y: position.y - tileSize.height),
            CGPoint(x: position.x, y: position.y + tileSize.height)
        ]
        
        for possiblePosition in possiblePitPositions {
            for pit in pitSprites {
                if pit.position.equalTo(possiblePosition) {
                    return true
                }
            }
        }
        
        return false
    }
    
    func smellWumpus(_ position: CGPoint) -> Bool {
        let dx = Int(floor(abs(wumpusSprite.position.x - position.x))),
        dy = Int(floor(abs(wumpusSprite.position.y - position.y)))
        
        return (dx == Int(tileSize.width)) && (dy == 0)
            || (dy == Int(tileSize.height)) && (dx == 0)
    }
    
    func seeGlittering(_ position: CGPoint) -> Bool {
        return position.equalTo(self.goldSprite.position)
    }
}





