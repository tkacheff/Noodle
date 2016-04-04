//
//  InfiniteGameScene.m
//  Noodle
//
//

#import "InfiniteGameScene.h"
#import "SceneryManager.h"
#import "InGameUI.h"
#import "Character.h"
#import "Camera.h"

#define NUM_OF_GEN_PLATFORMS 1

@implementation InfiniteGameScene

//////////////////////////////////////////////////////////
//
// Setup
///////////////////////////////////////////////
-(void) setup
{
    [super setup];
    
    self.shouldEnableEffects = YES;
    self.physicsWorld.contactDelegate = self;
    
    camera = [[Camera alloc] initWithSize:self.size type:CameraTypeInfiniteUp];
    [world addChild:camera];
    [self setCamera:camera];
    
    SKSpriteNode* background = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"TestBackground.png"]];
    [background setSize:CGSizeMake(self.size.width, world.scene.size.height * 20.0f)];
    [background setZPosition:1];
    
    [sceneryManager addChild:background];
    
   /* SKNode* spawnPoint = [self childNodeWithName:@"World//SpawnPoint"];
    if (spawnPoint)
    {
        character = [[Character alloc] initWithSize:self.size position:spawnPoint.position];
    }
    else
    {
        character = [[Character alloc] initWithSize:self.size position:CGPointMake(0, 0)];
    }

    character.zPosition = 5;
    [world addChild:character];*/
    
    generationLookAhead = 500;
    highestPlatformPos = character.position.y - character.size.height;
}

-(void) getPhysicsBodies:(SKPhysicsContact *)contact firstBody:(SKPhysicsBody**) firstBody secondBody:(SKPhysicsBody**) secondBody
{
    // Assign the two physics bodies so that the one with the lower category is always stored in firstBody
    if (contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask)
    {
        *firstBody = contact.bodyA;
        *secondBody = contact.bodyB;
    }
    else
    {
        *firstBody = contact.bodyB;
        *secondBody = contact.bodyA;
    }

}

//////////////////////////////////////////////////////////
//
// Infinite Level Logic
///////////////////////////////////////////////
- (void) createPlatform:(CGSize) size position:(CGPoint) position
{
    SKSpriteNode* genPlatform = [[SKSpriteNode alloc] initWithColor:[UIColor blueColor] size:size];
    genPlatform.position = position;
    
    genPlatform.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:genPlatform.frame.size];
    genPlatform.physicsBody.dynamic = NO;
    genPlatform.physicsBody.allowsRotation = YES;
    genPlatform.physicsBody.restitution = 0.0f;
    genPlatform.physicsBody.affectedByGravity = NO;
    
    [world addChild:genPlatform];
}

- (void) updateLevel
{
    float characterPos = [character position].y;
    if (highestPlatformPos < characterPos + generationLookAhead)
    {
        for (int i = 0; i < NUM_OF_GEN_PLATFORMS; i++)
        {
            const int xSize = 40 + arc4random() % 120;
            const int ySize = 10 + arc4random() % 30;
            
            const int xPosition = -160 + arc4random() % 320;
            const int yPosition = arc4random_uniform(50) + highestPlatformPos;
            
            [self createPlatform:CGSizeMake(xSize, ySize) position:CGPointMake(xPosition, yPosition)];
            
            int genYNoSize = yPosition;
            int genYHalfHeight = (ySize)/2;
            int genPlatformYPos = (genYNoSize + genYHalfHeight);
            if (genPlatformYPos > highestPlatformPos)
            {
                highestPlatformPos = genPlatformYPos + character.size.height * 2.0f;
            }
        }
    }
}

//////////////////////////////////////////////////////////
//
// Physics Logic
///////////////////////////////////////////////
- (void)didEndContact:(SKPhysicsContact *)contact
{
    SKPhysicsBody* firstBody, *secondBody;
    [self getPhysicsBodies:contact firstBody:&firstBody secondBody:&secondBody];
    
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
    SKPhysicsBody* firstBody, *secondBody;
    [self getPhysicsBodies:contact firstBody:&firstBody secondBody:&secondBody];
    
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
    
    CGVector camDistanceMoved = [camera update:0 totalTime:elapsedGameTime character:character];
    [sceneryManager update:0 camDelta:camDistanceMoved];
    
    [super pausedUpdate];
}

-(void)update:(CFTimeInterval)currentTime
{
    [self updateLevel];
    [character update:currentTime];

    CGVector camDistanceMoved = [camera update:currentTime totalTime:elapsedGameTime character:character];
    [sceneryManager update:currentTime camDelta:camDistanceMoved];
    
    [super update:currentTime];
}

- (void) didFinishUpdate
{
    [self centerOnNode:camera];
}

@end
