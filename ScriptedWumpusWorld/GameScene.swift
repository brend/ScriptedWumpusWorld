//
//  GameScene.swift
//  ScriptedWumpusWorld
//
//  Created by Philipp Brendel on 10.07.16.
//  Copyright (c) 2016 Entenwolf Software. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
    let TexIndexPit = 23,
        TexIndexExit = 24,
        TexIndexGold = 29
    
    let ActionDelayTimespan = 1.0
    
    var hunter: Hunter?
    
    let dimension = 4
    let tileSize = CGSize(width: 64, height: 64)
    var gridBase = CGPoint.zero
    var wumpusGridPosition = CGPoint(x: -1, y: -1)
    var hunterGridPosition = CGPoint(x: -1, y: -1)
    var goldGridPosition = CGPoint(x: -1, y: -1)
    var pitGridPositions: [CGPoint] = []
    
    var arrowCount = 1
    var wumpusScream = false,
        headBumped = false
    
    var goldStillOnBoard = true
    var wumpusStillAlive = true
    
    var lastAction: HunterAction?
    
    var hunterSprite, wumpusSprite, goldSprite, exitSprite: SKNode!
    var pitSprites: [SKNode] = []
    
    let actionLabel = SKLabelNode(text: "")
    
    var nextActionTime: CFTimeInterval?
    
    let ActorZPosition: CGFloat = 1.0,
        SensationZPosition: CGFloat = 2.0,
        HunterZPosition: CGFloat = 3.0,
        ProjectileZPosition: CGFloat = 4.0
    
    var gameState = GameState.running
    
    let scoreTracker = ScoreTracker()
    
    var splashScreenText: String?
    
    override func didMove(to view: SKView) {
        self.backgroundColor = NSColor(deviceCyan: 0.67, magenta: 0.71, yellow: 0.66, black: 0.79, alpha: 1)

        self.createWorld()
        
        // get things going
        self.actionCompleted()
        
        if let s = splashScreenText {
            displayMessage(s, duration: 2)
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        /* Called before each frame is rendered */
        
        switch self.gameState {
        case .running:
            updateRunningGame(currentTime)
        default:
            // no updates if the game is over
            break
        }
    }
    
    func updateRunningGame(_ currentTime: CFTimeInterval) {
        if let t = self.nextActionTime {
            if t <= CFAbsoluteTimeGetCurrent() {
                if let a = self.getHunterAction() {
                    self.announceHunterAction(a)
                    
                    self.nextActionTime = nil
                    
                    self.performHunterAction(a)
                    
                    // self.nextActionTime = nil
                    
                    self.wumpusScream = false
                    self.headBumped = false
                }
            }
        }
    }
    
    func findTheRumpus(_ direction: CGVector) -> CGPoint? {
        let wp = wumpusSprite.position,
            hp = hunterSprite.position
        let sx = sign(round(wp.x - hp.x)),
            sy = sign(round(wp.y - hp.y))
        
        if sx == sign(direction.dx) && sy == sign(direction.dy) {
            return wumpusSprite.position
        } else {
            return nil
        }
    }

    func actionCompleted() {
        // schedule next action with a small pause
        self.nextActionTime = CFAbsoluteTimeGetCurrent() + ActionDelayTimespan
        self.checkGameState()
    }
    
    func announceHunterAction(_ action: HunterAction) {
        actionLabel.text = "Current action: \(action)"
    }
    
    func checkGameState() {
        // the game has been lost 
        // if the hunter steps on the square of the live wumpus
        if wumpusStillAlive
            && equalGridPositions(hunterSprite, node2: wumpusSprite)
        {
            let deathAnimation = SKAction.repeatForever(SKAction.rotate(byAngle: CGFloat(Double.pi), duration: 0.5))
            
            self.hunterSprite.run(deathAnimation)
            
            displayMessage("You succumbed to the Wumpus.")
            
            self.gameState = GameState.over
            
            scoreTracker.hasDied()
        }
        
        // the game has been lost
        // if the hunter steps on a square with a pit
        for pit in self.pitSprites {
            if equalGridPositions(pit, node2: hunterSprite) {
                let deathAnimation = SKAction.scale(to: 0, duration: 1)
                
                self.hunterSprite.run(deathAnimation)
                
                displayMessage("You feel into a bottomless pit.")
                
                self.gameState = .over
                
                scoreTracker.hasDied()
            }
        }
        
        // the game has been won
        // if the hunter exits the dungeon after getting the gold
        if lastAction == HunterAction.exit
            && equalGridPositions(hunterSprite.position, worldPosition2: exitSprite.position)
        {
            let exitAnimation = SKAction.scale(to: 0, duration: 1)
            
            self.hunterSprite.run(exitAnimation)
            
            displayMessage("You left the cave.")
            
            self.gameState = GameState.over
        }
        
        if self.gameState == GameState.over {
            displayScore()
        }
    }
    
    func getHunterAction() -> HunterAction? {
        let smell = self.smellWumpus(self.hunterSprite.position),
            breeze = self.feelBreeze(self.hunterSprite.position),
            glitter = self.seeGlittering(self.hunterSprite.position)

        let action = self.hunter?.getActionWithSmell(
                        smell,
                        breeze: breeze,
                        glitter: glitter,
                        bumped: self.headBumped,
                        scream: self.wumpusScream)
        
        if let i = action as? Int {
            return HunterAction(rawValue: Int32(i))
        } else {
            return nil
        }
    }
    
    func displayMessage(_ text: String, duration: CFTimeInterval? = nil) {
        let label = SKLabelNode(text: text)
        var action = SKAction.scale(to: 1, duration: 1)
        
        label.position = CGPoint(x: self.frame.origin.x + self.frame.width * 0.5,
                                           y: self.frame.origin.y + self.frame.height * 0.5)
        label.zPosition = 47
        label.fontName = "AvenirNext-Bold"
        label.setScale(17)
        
        if let d = duration {
            action = SKAction.sequence([action, SKAction.wait(forDuration: d), SKAction.removeFromParent()])
        }
        
        label.run(action)
        
        self.addChild(label)
    }
    
    func displayScore() {
        let label = SKLabelNode()
        
        label.text = "Score: \(scoreTracker.score). \(scoreTracker.text)"
        
        label.position = CGPoint(x: self.frame.origin.x + self.frame.width * 0.5,
                                 y: self.frame.origin.y + self.frame.height * 0.5
                                    - 2 * tileSize.height)
        label.zPosition = 47
        label.fontName = "AvenirNext-Bold"
        label.fontSize = 16
        label.setScale(17)
        label.run(SKAction.scale(to: 1, duration: 1))
        
        self.addChild(label)
    }
    
    func equalGridPositions(_ node1: SKNode, node2: SKNode) -> Bool {
        return equalGridPositions(node1.position, worldPosition2: node2.position)
    }
}





























