//
//  SceneBase.h
//  Noodle
//
//  Created by Ben Tkacheff on 3/5/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "Camera.h"

@class SceneryManager;
@class InGameUI;

@interface SceneBase : SKScene
{
    SceneryManager* sceneryManager;
    InGameUI* ui;
    
    Camera* camera;
    
    SKNode* world;
    
    BOOL isPaused;
}

+ (instancetype)unarchiveFromFile:(NSString *)file;
- (void) setup;

-(void) centerOnNode:(SKNode *) node;

-(void)pauseGame;
-(void)unpauseGame;
-(BOOL)getPaused;

-(void) setCamera:(Camera*) value;
-(Camera*) getCamera;

-(void) pausedUpdate;

@end
