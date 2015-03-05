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
            [InfiniteGameScene createPhysicsBodiesHelper:descendant];
        }
    }
}

+(void) createPhysicsBodies:(SKScene*) scene
{
    SKNode* world = [scene childNodeWithName:@"World"];
    if (world)
    {
        [InfiniteGameScene createPhysicsBodiesHelper:world];
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
    InfiniteGameScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    [InfiniteGameScene createPhysicsBodies:scene];
    
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
    self.physicsWorld.contactDelegate = self;
    
    world = [self childNodeWithName:@"World"];
    world.physicsBody = [SKPhysicsBody bodyWithEdgeLoopFromRect:CGRectMake(-self.frame.size.width/2.0f, -self.frame.size.height/2.0f, self.frame.size.width, self.frame.size.height * 2000.0f)];
    world.physicsBody.restitution = 0.0f;
    world.physicsBody.friction = 0.0f;
    
    camera = [[Camera alloc] initWithSize:self.size type:CameraTypeFollowPlayer];
    [world addChild:camera];
    
    sceneryManager = [[SceneryManager alloc] init];
    [self addChild:sceneryManager];
    
    SKSpriteNode* background = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"TestBackground.png"]];

    [background setSize:CGSizeMake(self.size.width, world.scene.size.height * 10.0f)];
    [background setZPosition:1];
    [sceneryManager addChild:background];
    
    character = [[Character alloc] initWithSize:self.size];
    character.zPosition = 5;
    [world addChild:character];
}

-(void)didMoveToView:(SKView *)view
{
    ui = [[InGameUI alloc] initWithView:self.view];
    
    [self setup];
    dispatch_async(dispatch_get_main_queue(), ^{
        self.scene.view.paused = YES;
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

-(void) setPaused:(BOOL)paused
{
    [super setPaused:paused];
    
    if (self.paused)
    {
        [self update:0];
    }
}


//////////////////////////////////////////////////////////
//
// Game Logic/Camera Updates
///////////////////////////////////////////////
-(void)update:(CFTimeInterval)currentTime
{
    [character update:currentTime];
    
    CGVector camDistanceMoved = [camera update:currentTime character:character];
    [sceneryManager update:currentTime camDelta:camDistanceMoved];
    [camera update:currentTime character:character];
}

- (void) didFinishUpdate
{
    [self centerOnNode:camera];
}

- (void) centerOnNode: (SKNode *) node
{
    CGPoint cameraPositionInScene = [node.scene convertPoint:node.position fromNode:node.parent];
    node.parent.position = CGPointMake(node.parent.position.x - cameraPositionInScene.x,
                                       node.parent.position.y - cameraPositionInScene.y);
}

@end
