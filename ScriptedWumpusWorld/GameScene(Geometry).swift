//
//  GameScene(Geometry).swift
//  ScriptedWumpusWorld
//
//  Created by Philipp Brendel on 12.09.16.
//  Copyright © 2016 Entenwolf Software. All rights reserved.
//

import Foundation

extension GameScene {
    var up: CGVector { get { return CGVector(dx: 0, dy: tileSize.height) } }
    var down: CGVector { get { return CGVector(dx: 0, dy: -tileSize.height) } }
    var left: CGVector { get { return CGVector(dx: -tileSize.width, dy: 0) } }
    var right: CGVector { get { return CGVector(dx: tileSize.width, dy: 0) } }

    func gridDistance(_ a: CGPoint, b: CGPoint) -> Double {
        return Double(abs(b.x - a.x) + abs(b.y - a.y))
    }
    
    func equalGridPositions(_ worldPosition1: CGPoint,
                            worldPosition2: CGPoint) -> Bool {
        let gp = worldToGrid(worldPosition1),
        gq = worldToGrid(worldPosition2)
        
        return gp.equalTo(gq)
    }
    
    func translate(_ point: CGPoint, vector: CGVector) -> CGPoint {
        return CGPoint(x: point.x + vector.dx,
                       y: point.y + vector.dy)
    }
    
    func roundPoint(_ point: CGPoint) -> CGPoint {
        return CGPoint(x: round(point.x), y: round(point.y))
    }
    
    func roundRect(_ rect: CGRect) -> CGRect {
        return CGRect(x: round(rect.origin.x),
                      y: round(rect.origin.y),
                      width: round(rect.size.width),
                      height: round(rect.size.height))
    }
    
    func insideCave(_ point: CGPoint) -> Bool {
        let gridSize = CGSize(width: CGFloat(dimension) * self.tileSize.width,
                              height: CGFloat(dimension) * self.tileSize.height)
        let gridRect = CGRect(origin: self.gridBase,
                              size: gridSize)
        
        return roundRect(gridRect).contains(roundPoint(point))
    }
    
    func gridToWorld(_ x: Int, y: Int) -> CGPoint {
        return CGPoint(x: gridBase.x + tileSize.width * CGFloat(x),
                       y: gridBase.y + tileSize.height * CGFloat(y))
    }
    
    func worldToGrid(_ worldPosition: CGPoint) -> CGPoint {
        return CGPoint(x: round((worldPosition.x - gridBase.x) / tileSize.width),
                       y: round((worldPosition.y - gridBase.y) / tileSize.height))
    }
    
    func directionToRotation(_ direction: CGVector) -> CGFloat {
        let angle: Double
        
        switch direction {
        case right:
            angle = 0
        case up:
            angle = M_PI_2
        case left:
            angle = M_PI
        case down:
            angle = -M_PI_2
        default:
            angle = M_PI_4
        }
        
        return CGFloat(angle)
    }
    
    func sign(_ f: CGFloat) -> Int {
        return (f > 0) ? 1 : ((f < 0) ? -1 : 0)
    }
}



































