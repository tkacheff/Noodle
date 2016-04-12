//
//  SceneBase.m
//  Noodle
//
//  Created by Ben Tkacheff on 3/5/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import "SceneBase.h"

#import "InfiniteGameScene.h"
#import "SceneryManager.h"
#import "InGameUI.h"
#import "Character.h"

@implementation SceneBase

//////////////////////////////////////////////////////////
//
// Level unpackaging
///////////////////////////////////////////////
+(void) createPhysicsBodiesHelper:(SKNode*) parent
{
    for (SKNode* descendant in parent.children)
    {
        if ([descendant isKindOfClass:[SKSpriteNode class]])
        {
            SKSpriteNode* spriteNode = (SKSpriteNode*)descendant;
            if (spriteNode.zRotation == 0)
            {
                spriteNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:spriteNode.frame.size];
                spriteNode.physicsBody.dynamic = NO;
                spriteNode.physicsBody.allowsRotation = YES;
                spriteNode.physicsBody.restitution = 0.0f;
                spriteNode.physicsBody.affectedByGravity = NO;
            }
        }
        
        if (descendant.children.count > 0)
        {
            [SceneBase createPhysicsBodiesHelper:descendant];
        }
    }
}

+(void) createPhysicsBodies:(SKScene*) scene
{
    SKNode* world = [scene childNodeWithName:@"World"];
    if (world)
    {
        [SceneBase createPhysicsBodiesHelper:world];
    }
}

+ (instancetype)unarchiveFromFile:(NSString *)file
{
    /* Unarchive the file to an SKScene object */
    NSData *data = [NSData dataWithContentsOfFile:file
                                          options:NSDataReadingMappedIfSafe
                                            error:nil];
    NSKeyedUnarchiver *arch = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    [arch setClass:self forClassName:@"SKScene"];
    SceneBase *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    [SceneBase createPhysicsBodies:scene];
    
    return scene;
}

//////////////////////////////////////////////////////////
//
// Setup
///////////////////////////////////////////////
-(void) setup
{
    elapsedGameTime = [[NSNumber alloc] initWithLongLong:0];
    lastFrameTime = 0;
    
    self.shouldEnableEffects = YES;
    self.physicsWorld.gravity = CGVectorMake(0.0, -6.0);
  
    world = [self childNodeWithName:@"World"];
    world.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(-self.frame.size.width/2.0f, -self.frame.size.height/2.0f, self.frame.size.width, self.frame.size.height * 2000.0f)];
    world.physicsBody.restitution = 0.0f;
    world.physicsBody.friction = 0.0f;

    sceneryManager = [[SceneryManager alloc] init];
    [self addChild:sceneryManager];
    
    SKNode* spawnPoint = [self childNodeWithName:@"World//SpawnPoint"];
    if (spawnPoint)
    {
        character = [[Character alloc] initWithSize:self.size position:spawnPoint.position];
    }
    else
    {
        character = [[Character alloc] initWithSize:self.size position:CGPointMake(0, 0)];
    }
    
    character.zPosition = 5;
    [world addChild:character];
    
    [self registerAppTransitionObservers];
}

-(void)didMoveToView:(SKView *)view
{
    [self setup];
    
    ui = [[InGameUI alloc] initWithView:self.view];
}

-(void) setViewController:(UIViewController*) presentingController
{
    uiViewController = presentingController;
}

-(UIViewController*) getPresentingController
{
    return uiViewController;
}


////////////////////////////////////////////////////////////
//
// Pause/State Handling
////////////////////////////////////////////////////////////

-(void)update:(CFTimeInterval)currentTime
{
    if (lastFrameTime != 0)
    {
        CGFloat delta = currentTime - lastFrameTime;
        elapsedGameTime = @([elapsedGameTime floatValue] + delta);
    }
    lastFrameTime = currentTime;
    
    CGFloat charYPos = character.position.y + character.size.height/2.0f;
    CGFloat lowestVisiblePoint = camera.position.y - self.frame.size.height/2.0f;
    
    if (charYPos < lowestVisiblePoint)
    {
        [self gameOver];
    }
}

// override these in inherited classes for update when game pauses
-(void) pausedUpdate
{
    lastFrameTime = 0;
}

-(void)pauseGame
{
    isPaused = YES;
    self.scene.paused = YES;
    self.scene.view.paused = YES;
    [self pausedUpdate];
}
-(void)unpauseGame
{
    isPaused = NO;
    self.scene.paused = NO;
    self.scene.view.paused = NO;
}

-(BOOL) getPaused
{
    return isPaused;
}

-(void)quitGame
{
    [self pauseGame];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"KillGame" object:self];
}

-(void) gameOver
{
    //todo: cool post scores -> death thing -> menu
}

-(void) applicationDidEnterBackground
{
    [self pauseGame];
}
-(void)applicationWillEnterForeground
{
    //[self unpauseGame];
}
-(void)applicationWillResignActive
{
    if (!isPaused)
    {
        [self pauseGame];
    }
}
-(void)registerAppTransitionObservers
{
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillResignActive)
                                                 name:UIApplicationWillResignActiveNotification
                                               object:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationDidEnterBackground)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:NULL];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(applicationWillEnterForeground)
                                                 name:UIApplicationWillEnterForegroundNotification
                                               object:NULL];
}


//////////////////////////////////////////////////////////
//
// Game Logic/Camera Updates
///////////////////////////////////////////////
- (void) centerOnNode: (SKNode *) node
{
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x - cameraPositionInScene.x,
                                       node.parent.position.y - cameraPositionInScene.y);
}

-(void) setCamera:(Camera*) value
{
    camera = value;
}

-(Camera*) getCamera
{
    return camera;
}

@end
