//
//  GameScene(Actions).swift
//  ScriptedWumpusWorld
//
//  Created by Philipp Brendel on 12.09.16.
//  Copyright © 2016 Entenwolf Software. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    func performHunterAction(_ hunterAction: HunterAction) {
        //print(">>> Performing action \(hunterAction)")
        
        lastAction = hunterAction
        
        scoreTracker.actionPerformed()
        
        switch hunterAction {
        case .moveLeft:
            self.moveHunter(left)
        case .moveRight:
            self.moveHunter(right)
        case .moveUp:
            self.moveHunter(up)
        case .moveDown:
            self.moveHunter(down)
        case .shootLeft:
            self.shootArrow(left)
        case .shootRight:
            self.shootArrow(right)
        case .shootUp:
            self.shootArrow(up)
        case .shootDown:
            self.shootArrow(down)
        case .pickUp:
            self.pickUpGold()
            break
        case .exit:
            self.exitTheCave()
            break
        }
    }
    
    func moveHunter(_ direction: CGVector) {
        let completionHandler = {() in self.actionCompleted()}
        let action: SKAction
        
        if !insideCave(translate(hunterSprite.position, vector: direction)) {
            self.headBumped = true
            
            action = SKAction.rotate(byAngle: CGFloat(Double.pi * 2), duration: 0.5)
        } else {
            action = SKAction.move(by: direction, duration: 0.5)
        }
        
        self.hunterSprite?.run(action, completion: completionHandler)
    }
    
    func shootArrow(_ direction: CGVector) {
        if arrowCount < 1 {
            let a1 = SKAction.scale(to: 0.3, duration: 0.2)
            let a2 = SKAction.scale(to: 1.0, duration: 0.5)
            
            hunterSprite?.run(SKAction.sequence([a1, a2]), completion: self.actionCompleted)
            
            return
        }
        
        let wumpusPosition = findTheRumpus(direction)
        let arrowDestination =
            wumpusPosition ?? CGPoint(x: hunterSprite.position.x + 4 * CGFloat(sign(direction.dx)) * tileSize.width,
                                      y: hunterSprite.position.y + 4 * CGFloat(sign(direction.dy)) * tileSize.height)
        
        let flightDistance = gridDistance(hunterGridPosition, b: worldToGrid(arrowDestination))
        
        // TODO: Compute duration = arrowSpeed * distance
        let moveAction = SKAction.move(to: arrowDestination, duration: flightDistance * 0.1)
        let arrowSprite = SKSpriteNode(imageNamed: "arrow")
        
        arrowSprite.position = hunterSprite.position
        arrowSprite.zPosition = ProjectileZPosition
        arrowSprite.zRotation = directionToRotation(direction)
        addChild(arrowSprite)
        arrowSprite.run(moveAction,
                              completion:
            {
                self.scoreTracker.shotArrow()
                
                if wumpusPosition != nil {
                    self.wumpusSprite?.removeFromParent()
                    self.wumpusScream = true
                    self.wumpusStillAlive = false
                    self.scoreTracker.killedWumpus()
                }
                
                arrowSprite.removeFromParent()
                self.arrowCount -= 1
                
                self.actionCompleted()
        })
    }
    
    func exitTheCave() {
        if equalGridPositions(hunterSprite, node2: exitSprite) {
            
        } else {
            // TODO: Indicate the failure to leave the cave
        }
        
        self.actionCompleted()
    }
    
    func pickUpGold() {
        if goldStillOnBoard
            && equalGridPositions(hunterSprite, node2: goldSprite) {
            let pickupAnimation = SKAction.removeFromParent()
            
            goldSprite.run(pickupAnimation)
            
            displayMessage("Good! Now find the exit!", duration: 3)
            
            goldStillOnBoard = false
            scoreTracker.gotGold()
        } else {
            // TODO: Indicate the failure to pick up the gold
        }
        
        self.actionCompleted()
    }
}






















