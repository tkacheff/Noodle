//
//  SceneBase.h
//  Noodle
//
//  Created by Ben Tkacheff on 3/5/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

#define PAUSE_GAME_NOTIFICATION @"GamePaused"

@class SceneryManager;
@class InGameUI;

@interface SceneBase : SKScene
{
    SceneryManager* sceneryManager;
    InGameUI* ui;
    
    SKNode* world;
    
    BOOL isPaused;
}

+ (instancetype)unarchiveFromFile:(NSString *)file;
- (void) setup;

-(void) centerOnNode:(SKNode *) node;

-(void)pauseGame;
-(void)unpauseGame;
-(BOOL)getPaused;

@end
