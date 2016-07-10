//
//  GuiHunter.swift
//  ScriptedWumpusWorld
//
//  Created by Philipp Brendel on 06.08.16.
//  Copyright © 2016 Entenwolf Software. All rights reserved.
//

import Foundation

class GuiHunter: NSObject, Hunter {
    
    var actionQueue = Array<HunterAction>()
    
    func clearActionQueue() {
        actionQueue.removeAll()
    }
        
    @IBAction func enqueueMoveUp(_ sender: AnyObject?) {
        actionQueue.append(HunterAction.moveUp)
    }
    
    @IBAction func enqueueMoveDown(_ sender: AnyObject?) {
        actionQueue.append(HunterAction.moveDown)
    }
    
    @IBAction func enqueueMoveLeft(_ sender: AnyObject?) {
        actionQueue.append(HunterAction.moveLeft)
    }
    
    @IBAction func enqueueMoveRight(_ sender: AnyObject?) {
        actionQueue.append(HunterAction.moveRight)
    }
    
    @IBAction func enqueueShootUp(_ sender: AnyObject?) {
        actionQueue.append(HunterAction.shootUp)
    }
    
    @IBAction func enqueueShootDown(_ sender: AnyObject?) {
        actionQueue.append(HunterAction.shootDown)
    }
    
    @IBAction func enqueueShootLeft(_ sender: AnyObject?) {
        actionQueue.append(HunterAction.shootLeft)
    }
    
    @IBAction func enqueueShootRight(_ sender: AnyObject?) {
        actionQueue.append(HunterAction.shootRight)
    }
    
    @IBAction func enqueuePickUp(_ sender: AnyObject?) {
        actionQueue.append(HunterAction.pickUp)
    }
    
    @IBAction func enqueueExit(_ sender: AnyObject?) {
        actionQueue.append(HunterAction.exit)
    }
    
    func getActionWithSmell(_ smell: Bool,
                            breeze: Bool,
                            glitter: Bool,
                            bumped: Bool,
                            scream: Bool) -> NSNumber?
    {
        if let action = actionQueue.first {
            actionQueue.removeFirst()
            
            return NSNumber(value: action.rawValue as Int32)
        } else {
            return nil
        }
    }
    
    let isManuallyControlled = true
}






























