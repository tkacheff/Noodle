//
//  MyScene.m
//  Noodle
//
//

#import "InfiniteGameScene.h"
#import "Character.h"
#import "Camera.h"
#import "SceneryManager.h"
#import "InGameUI.h"

@implementation InfiniteGameScene

//////////////////////////////////////////////////////////
//
// Setup
///////////////////////////////////////////////
-(void) setup
{
    [super setup];
    
    self.physicsWorld.contactDelegate = self;
    self.shouldEnableEffects = YES;
    
    camera = [[Camera alloc] initWithSize:self.size type:CameraTypeFollowPlayer];
    [world addChild:camera];
    
    SKSpriteNode* background = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"TestBackground.png"]];

    [background setSize:CGSizeMake(self.size.width, world.scene.size.height * 20.0f)];
    [background setZPosition:1];
    
    [sceneryManager addChild:background];
    
    character = [[Character alloc] initWithSize:self.size];
    character.zPosition = 5;
    [world addChild:character];

    CIFilter *blur = [CIFilter filterWithName:@"CIGaussianBlur" keysAndValues:@"inputRadius", @1.0f, nil];
    [self setFilter:blur];
    
    /*
    SKShader* shader = [SKShader shaderWithFileNamed:@"Shaders/TestShader.fsh"];
    self.shader  = shader;*/
    
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
        [character endTouchBody:secondBody contactNormal:contact.contactNormal];
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
