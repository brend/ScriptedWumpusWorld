//
//  HunterAction.swift
//  ScriptedWumpusWorld
//
//  Created by Philipp Brendel on 23.07.16.
//  Copyright © 2016 Entenwolf Software. All rights reserved.
//

import Foundation

enum HunterAction: Int32 {
    case moveLeft,
        moveRight,
        moveUp,
        moveDown,
        shootLeft,
        shootRight,
        shootUp,
        shootDown,
        pickUp,
        exit
}
