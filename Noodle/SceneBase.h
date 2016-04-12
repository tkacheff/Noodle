//
//  SceneBase.h
//  Noodle
//
//  Created by Ben Tkacheff on 3/5/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#include "Camera.h"

@class SceneryManager;
@class InGameUI;
@class Character;

@interface SceneBase : SKScene
{
    SceneryManager* sceneryManager;
    InGameUI* ui;
    UIViewController* uiViewController;
    
    Camera* camera;
    
    Character* character;
    
    SKNode* world;
    
    BOOL isPaused;
    
    NSNumber* elapsedGameTime;
    CFTimeInterval lastFrameTime;
}

+ (instancetype)unarchiveFromFile:(NSString *)file;
- (void) setup;

-(void) centerOnNode:(SKNode *) node;

-(void)pauseGame;
-(void)unpauseGame;
-(BOOL)getPaused;

-(void)quitGame;

-(void) setCamera:(Camera*) value;
-(Camera*) getCamera;

-(void) pausedUpdate;

-(void) setViewController:(UIViewController*) presentingController;
-(UIViewController*) getPresentingController;

@end
