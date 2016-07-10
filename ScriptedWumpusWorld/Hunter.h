//
//  Hunter.h
//  ScriptedWumpusWorld
//
//  Created by Philipp Brendel on 10.07.16.
//  Copyright © 2016 Entenwolf Software. All rights reserved.
//

#import <Foundation/Foundation.h>
#include "lua.h"
#include "lualib.h"
#include "lauxlib.h"

@protocol Hunter
- (NSNumber *) getActionWithSmell: (BOOL) smell
                           breeze: (BOOL) breeze
                          glitter: (BOOL) glitter
                           bumped: (BOOL) bumped
                           scream: (BOOL) scream;

@property (readonly) BOOL isManuallyControlled;
@end

@interface LuaHunter : NSObject<Hunter>

- (id) init: (NSString*) script
      error: (NSString**) error;

- (NSNumber *) getActionWithSmell: (BOOL) smell
                    breeze: (BOOL) breeze
                   glitter: (BOOL) glitter
                    bumped: (BOOL) bumped
                    scream: (BOOL) scream;

@property (readonly) BOOL isManuallyControlled;

@end
