//
//  SceneBase.h
//  Noodle
//
//  Created by Ben Tkacheff on 3/5/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

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

-(void) pausedUpdate;

@end
