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
            spriteNode.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:spriteNode.frame.size];
            spriteNode.physicsBody.dynamic = NO;
            spriteNode.physicsBody.allowsRotation = NO;
            spriteNode.physicsBody.restitution = 0.0f;
            spriteNode.physicsBody.affectedByGravity = NO;
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
-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size])
    {
        self.size = size;
        [self setup];
    }
    return self;
}

-(void) setup
{
    self.scaleMode = SKSceneScaleModeAspectFill;
    self.physicsWorld.gravity = CGVectorMake(0.0, -6.0);
  
    world = [self childNodeWithName:@"World"];
    world.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(-self.frame.size.width/2.0f, -self.frame.size.height/2.0f, self.frame.size.width, self.frame.size.height * 2000.0f)];
    world.physicsBody.restitution = 0.0f;
    world.physicsBody.friction = 0.0f;

    sceneryManager = [[SceneryManager alloc] init];
    [self addChild:sceneryManager];
    
    [self registerAppTransitionObservers];
}

-(void)didMoveToView:(SKView *)view
{
    ui = [[InGameUI alloc] initWithView:self.view];
    [self setup];
}


////////////////////////////////////////////////////////////
//
// Pause/State Handling
////////////////////////////////////////////////////////////

-(void) pausedUpdate
{
    // override these in inherited classes for update when game pauses
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

-(void) applicationDidEnterBackground
{
    [self pauseGame];
}
-(void)applicationWillEnterForeground
{
    [self unpauseGame];
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

@end
