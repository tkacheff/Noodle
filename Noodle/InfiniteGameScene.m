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
    
    /*SKShader* shader = [SKShader shaderWithFileNamed:@"Shaders/TestShader.fsh"];
    shader.uniforms = @[[SKUniform uniformWithName:@"u_texture" floatVector2:GLKVector2Make(0,0)]];
    background.shader = shader;*/
    
    [sceneryManager addChild:background];
    
    character = [[Character alloc] initWithSize:self.size];
    character.zPosition = 5;
    [world addChild:character];
    
    [self pauseGame];
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
-(void)update:(CFTimeInterval)currentTime
{
    if (isPaused)
    {
        return;
    }
    
    [character update:currentTime];
    
    CGVector camDistanceMoved = [camera update:currentTime character:character];
    [sceneryManager update:currentTime camDelta:camDistanceMoved];
    [camera update:currentTime character:character];
}

- (void) didFinishUpdate
{
    if (isPaused)
    {
        return;
    }
    
    [self centerOnNode:camera];
}

@end
