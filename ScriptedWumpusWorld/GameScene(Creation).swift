//
//  GameScene(Creation).swift
//  ScriptedWumpusWorld
//
//  Created by Philipp Brendel on 12.09.16.
//  Copyright © 2016 Entenwolf Software. All rights reserved.
//

import Foundation
import SpriteKit

extension GameScene {
    func createWorld() {
        let tileTextures = loadTileset()
        
        // create the grid
        self.gridBase = CGPoint(x:frame.midX - CGFloat(dimension) * tileSize.width * 0.5,
                                y:frame.midY - CGFloat(dimension) * tileSize.height * 0.5)
        
        let floorTexture = tileTextures[26] // TODO: randomize floor tiles
        
        for x in 0...(dimension-1) {
            for y in 0...(dimension-1) {
                let floorSprite = SKSpriteNode(texture: floorTexture, size: tileSize)
                
                floorSprite.position = gridToWorld(x, y: y)
                
                self.addChild(floorSprite)
            }
        }
        
        // create the walls
        for x in -2...(dimension+1) {
            for y in -2...(dimension+1) {
                // only draw surrounding tiles
                if !(x < 0 || x >= dimension
                    || y < 0 || y >= dimension) {
                    continue
                }
                
                let wx, wy: Int
                
                switch x {
                case -2:
                    wx = 0
                case -1:
                    wx = 1
                case dimension:
                    wx = 3
                case dimension+1:
                    wx = 4
                default:
                    // TODO: pick at random
                    wx = 2
                }
                
                switch y {
                case -2:
                    wy = 0
                case -1:
                    wy = 1
                case dimension:
                    wy = 2
                case dimension+1:
                    wy = 3
                default:
                    // TODO: pick at random
                    wy = 1
                }
                
                // WARNING: constant "5"
                let wallTexture = tileTextures[wx + wy * 5]
                let wallSprite = SKSpriteNode(texture: wallTexture)
                
                wallSprite.position = gridToWorld(x, y: y)
                
                self.addChild(wallSprite)
            }
        }
        
        // create the HUD
        actionLabel.position = CGPoint(x: self.frame.width / 2, y: 20)
        actionLabel.zPosition = 17
        actionLabel.fontSize = 20
        
        self.addChild(actionLabel)
        
        // create the actors
        // wumpus
        let (wumpusSprite, wumpusGridPosition) = self.createActor("wumpus")
        
        self.addChild(wumpusSprite)
        self.wumpusGridPosition = wumpusGridPosition
        self.wumpusSprite = wumpusSprite
        
        // gold
        let goldTexture = tileTextures[TexIndexGold]
        let (goldSprite, _) = self.createActor(goldTexture)
        
        self.addChild(goldSprite)
        self.goldSprite = goldSprite
        
        // two pits
        for _ in 1...2 {
            // TODO: pick texture at random
            let pitTexture = tileTextures[TexIndexPit]
            let (pitSprite, pitGridPosition) = self.createActor(pitTexture)
            
            self.addChild(pitSprite)
            self.pitGridPositions.append(pitGridPosition)
            self.pitSprites.append(pitSprite)
        }
        
        // sensation icons
        for j in 0...(dimension-1) {
            for i in 0...(dimension-1) {
                let position = gridToWorld(i, y: j)
                
                if feelBreeze(position) {
                    let breezeSprite = SKSpriteNode(imageNamed: "breeze")
                    
                    breezeSprite.position = position
                    breezeSprite.zPosition = SensationZPosition
                    
                    addChild(breezeSprite)
                }
                
                if smellWumpus(position) {
                    let stankSprite = SKSpriteNode(imageNamed: "stench")
                    
                    stankSprite.position = position
                    stankSprite.zPosition = SensationZPosition
                    
                    addChild(stankSprite)
                }
            }
        }
        
        // the hunter
        let (hunterSprite, hunterGridPosition) = self.createActor("hunter")
        
        hunterSprite.zPosition = HunterZPosition
        
        self.addChild(hunterSprite)
        self.hunterSprite = hunterSprite
        self.hunterGridPosition = hunterGridPosition
        
        // the exit
        let exitTexture = tileTextures[TexIndexExit]
        let exitSprite = SKSpriteNode(texture: exitTexture)
        
        exitSprite.position = self.hunterSprite.position
        exitSprite.zPosition = ActorZPosition - 0.5
        
        self.addChild(exitSprite)
        
        self.exitSprite = exitSprite
    }
    
    func actorPresent(_ gridPosition: CGPoint) -> Bool {
        return gridPosition == wumpusGridPosition
            || gridPosition == goldGridPosition
            || pitGridPositions.contains(gridPosition)
    }
    
    func createActor(_ texture: SKTexture) -> (SKNode, CGPoint) {
        var x: Int, y: Int
        
        repeat {
            x = Int(arc4random()) % self.dimension
            y = Int(arc4random()) % self.dimension
        } while self.actorPresent(CGPoint(x: x, y: y))
        
        
        let sprite = SKSpriteNode(texture: texture)
        
        sprite.position = gridToWorld(x, y: y)
        sprite.zPosition = ActorZPosition
        
        return (sprite, CGPoint(x: Int(x), y: Int(y)))
    }
    
    func createActor(_ imageNamed: String) -> (SKNode, CGPoint) {
        var x: Int, y: Int
        
        repeat {
            x = Int(arc4random()) % self.dimension
            y = Int(arc4random()) % self.dimension
        } while self.actorPresent(CGPoint(x: x, y: y))
        
        
        let sprite = SKSpriteNode(imageNamed: imageNamed)
        
        sprite.position = gridToWorld(x, y: y)
        sprite.zPosition = ActorZPosition
        
        return (sprite, CGPoint(x: Int(x), y: Int(y)))
    }
    
    func loadTileset() -> [SKTexture] {
        let tilesetTexture = SKTexture(imageNamed: "tileset")
        let nx = 5, ny = 6
        let w = 1.0 / CGFloat(nx), h = 1.0 / CGFloat(ny)
        var tileTextures = [SKTexture]()
        
        for y in 0..<ny {
            for x in 0..<nx {
                let rect = CGRect(x: w * CGFloat(x),
                                  y: h * CGFloat(y),
                                  width: w,
                                  height: h)
                let t = SKTexture(rect: rect, in: tilesetTexture)
                
                tileTextures.append(t)
            }
        }
        
        return tileTextures
    }
}


































