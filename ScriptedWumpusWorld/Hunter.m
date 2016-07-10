//
//  Hunter.m
//  ScriptedWumpusWorld
//
//  Created by Philipp Brendel on 10.07.16.
//  Copyright © 2016 Entenwolf Software. All rights reserved.
//

#import "Hunter.h"

@interface LuaHunter()
@property (nonatomic, assign) lua_State *luaState;
@end

/* movement */
static int move_up(lua_State *L) {
    /*
    SKNode *girl = (__bridge SKNode *) (lua_touserdata(L, 1));
    float dx = lua_tonumber(L, 2);
    float dy = lua_tonumber(L, 3);
*/
    
    return 0;
}

static int move_down(lua_State *L) {
    return 0;
}

static int move_left(lua_State *L) {
    return 0;
}

static int move_right(lua_State *L) {
    return 0;
}

/* shooting the arrow */
static int shoot_up(lua_State *L) {
    return 0;
}

static int shoot_down(lua_State *L) {
    return 0;
}

static int shoot_left(lua_State *L) {
    return 0;
}

static int shoot_right(lua_State *L) {
    return 0;
}

/* the rest of the gang */
static int pick_up_gold(lua_State *L) {
    return 0;
}

static int leave_dungeon(lua_State *L) {
    return 0;
}

// Lua registration

static const struct luaL_Reg hunterlib_f [] = {
    {"move_left", move_left},
    {"move_right", move_right},
    {"move_up", move_up},
    {"move_down", move_down},
    
    {"shoot_left", shoot_left},
    {"shoot_right", shoot_right},
    {"shoot_up", shoot_up},
    {"shoot_down", shoot_down},
    
    {"pick_up_gold", pick_up_gold},
    {"leave_dungeon", leave_dungeon},
    {NULL, NULL}
};

int luaopen_mylib (lua_State *L){
    
    luaL_register(L, "hunter", hunterlib_f);
    
    return 1;
}


@implementation LuaHunter

const char *ActionFunctionName = "get_action";

- (id) init: (NSString *) script
      error: (NSString **) error
{
    *error = NULL;
    
    if (self = [super init]) {
        self.luaState = luaL_newstate();
        
        luaL_openlibs(self.luaState);
        lua_settop(self.luaState, 0);
        
        int err;
        const char *utf8script = [script cStringUsingEncoding:[NSString defaultCStringEncoding]];
        
        err = luaL_loadstring(self.luaState, utf8script);
        
        if (0 != err) {
            NSLog(@"cannot compile lua file: %s", lua_tostring(self.luaState, -1));
            *error = [NSString stringWithFormat: @"cannot compile lua file: %s", lua_tostring(self.luaState, -1)];
            
            return nil;
        }
        
        err = lua_pcall(self.luaState, 0, 0, 0);
        if (0 != err) {
            NSLog(@"cannot run lua file: %s", lua_tostring(self.luaState, -1));
            *error = [NSString stringWithFormat: @"cannot run lua file: %s", lua_tostring(self.luaState, -1)];
            
            return nil;
        }
        
        // Test if the script defines the required "hunter action" function
        lua_getglobal(self.luaState, ActionFunctionName);
        
        if (lua_isnil(self.luaState, -1) == 1) {
            NSLog(@"Couldn't get function '%s': %s", ActionFunctionName, lua_tostring(self.luaState, -1));
            *error = [NSString stringWithFormat: @"Script doesn't define required function '%s'", ActionFunctionName];
            
            return nil;
        }
    }
    
    return self;
}

- (NSNumber *) getActionWithSmell: (BOOL) smell
                    breeze: (BOOL) breeze
                   glitter: (BOOL) glitter
                    bumped: (BOOL) bumped
                    scream: (BOOL) scream
{
    // TODO: Decide on best course of action if lua call fails
    
    // put the pointer to the lua function we want on top of the stack
    lua_getglobal(self.luaState, ActionFunctionName);
    
    if (lua_isnil(self.luaState, -1) == 1) {
        NSLog(@"Couldn't get function '%s': %s", ActionFunctionName, lua_tostring(self.luaState, -1));
        // TODO: Decide on correct course of action
        return nil;
    }
    
    lua_pushboolean(self.luaState, smell);
    lua_pushboolean(self.luaState, breeze);
    lua_pushboolean(self.luaState, glitter);
    lua_pushboolean(self.luaState, bumped);
    lua_pushboolean(self.luaState, scream);
    
    // call the function on the stack with 5 arguments and 1 result
    int err = lua_pcall(self.luaState, 5, 1, 0);
    if (0 != err) {
        NSLog(@"Error during lua function call: %s", lua_tostring(self.luaState, -1));
        // TODO: Decide on correct course of action
        return nil;
    }
    
    lua_Integer result = lua_tointeger(self.luaState, -1);
    
    // Is there a better way than casting?
    return [NSNumber numberWithInt: (int) result];
}

- (BOOL) isManuallyControlled
{
    return NO;
}

@end
































