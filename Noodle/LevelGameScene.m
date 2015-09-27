//
//  LevelGameScene.m
//  Noodle
//
//

#import "LevelGameScene.h"
#import "Character.h"
#import "Camera.h"
#import "SceneryManager.h"
#import "InGameUI.h"

@implementation LevelGameScene

//////////////////////////////////////////////////////////
//
// Setup
///////////////////////////////////////////////
-(void) setup
{
    [super setup];

    self.shouldEnableEffects = YES;
    self.physicsWorld.contactDelegate = self;
    
    camera = [[Camera alloc] initWithSize:self.size type:CameraTypeFollowPlayer];
    [world addChild:camera];
    [self setCamera:camera];
    
    SKSpriteNode* background = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"TestBackground.png"]];
    [background setSize:CGSizeMake(self.size.width, world.scene.size.height * 20.0f)];
    [background setZPosition:1];
    
    [sceneryManager addChild:background];
    
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
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self pauseGame];
    });
}

//////////////////////////////////////////////////////////
//
// Physics Logic
///////////////////////////////////////////////
- (void)didEndContact:(SKPhysicsContact *)contact
{
    // 1 Create local variables for two physics bodies
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;
    // 2 Assign the two physics bodies so that the one with the lower category is always stored in firstBody
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if (firstBody == character.physicsBody)
    {
        [character endTouchBody:secondBody contactNormal:contact.contactNormal];
    }
    else if(secondBody == character.physicsBody)
    {
        [character endTouchBody:firstBody contactNormal:contact.contactNormal];
    }
}

- (void)didBeginContact:(SKPhysicsContact*)contact
{
    // 1 Create local variables for two physics bodies
    SKPhysicsBody* firstBody;
    SKPhysicsBody* secondBody;
    // 2 Assign the two physics bodies so that the one with the lower category is always stored in firstBody
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        firstBody = contact.bodyA;
        secondBody = contact.bodyB;
    }
    else
    {
        firstBody = contact.bodyB;
        secondBody = contact.bodyA;
    }
    
    if (firstBody == character.physicsBody)
    {
        [character startTouchBody:secondBody contactNormal:contact.contactNormal];
    }
    else if(secondBody == character.physicsBody)
    {
        [character startTouchBody:firstBody contactNormal:contact.contactNormal];
    }
}


//////////////////////////////////////////////////////////
//
// Game Logic/Camera Updates
///////////////////////////////////////////////
-(void) pausedUpdate
{
    [character update:0];
    
    CGVector camDistanceMoved = [camera update:0 character:character];
    [sceneryManager update:0 camDelta:camDistanceMoved];
}

-(void)update:(CFTimeInterval)currentTime
{
    [character update:currentTime];

    CGVector camDistanceMoved = [camera update:currentTime character:character];
    [sceneryManager update:currentTime camDelta:camDistanceMoved];
}

- (void) didFinishUpdate
{
    [self centerOnNode:camera];
}

@end
