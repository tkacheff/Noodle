//
//  MyScene.m
//  Noodle
//
//

#import "FirstGameScene.h"
#import "Character.h"
#import "Camera.h"
#import "SceneryManager.h"
#import "InGameUI.h"
/*
static NSString* ballCategoryName = @"ball";
static NSString* paddleCategoryName = @"paddle";
static NSString* blockCategoryName = @"block";
static NSString* blockNodeCategoryName = @"blockNode";

static const uint32_t ballCategory  = 0x1 << 0;  // 00000000000000000000000000000001
static const uint32_t bottomCategory = 0x1 << 1; // 00000000000000000000000000000010
static const uint32_t blockCategory = 0x1 << 2;  // 00000000000000000000000000000100
static const uint32_t paddleCategory = 0x1 << 3; // 00000000000000000000000000001000*/

@implementation FirstGameScene

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
            [FirstGameScene createPhysicsBodiesHelper:descendant];
        }
    }
}

+(void) createPhysicsBodies:(SKScene*) scene
{
    SKNode* world = [scene childNodeWithName:@"World"];
    if (world)
    {
        [FirstGameScene createPhysicsBodiesHelper:world];
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
    FirstGameScene *scene = [arch decodeObjectForKey:NSKeyedArchiveRootObjectKey];
    [arch finishDecoding];
    
    [FirstGameScene createPhysicsBodies:scene];
    
    return scene;
}

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
    
    CGSize size = self.size;
    
    camera = [[Camera alloc] initWithSize:size type:CameraTypeInfiniteUp];
    [world addChild:camera];
    
    sceneryManager = [[SceneryManager alloc] init];
    [self addChild:sceneryManager];
    
    SKSpriteNode* background = [[SKSpriteNode alloc] initWithTexture:[SKTexture textureWithImageNamed:@"TestBackground.png"]];

    [background setSize:CGSizeMake(size.width, world.scene.size.height * 10.0f)];
    [background setZPosition:1];
    [sceneryManager addChild:background];
    
    character = [[Character alloc] initWithSize:size];
    character.zPosition = 5;
    [world addChild:character];
}

-(void)didMoveToView:(SKView *)view
{
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 32, 32)];
    button.backgroundColor = [UIColor blueColor];
    //button set
    [self.view addSubview:button];
}

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
        [character startTouchBody:secondBody contactNormal:contact.contactNormal];
    }
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


-(void)update:(CFTimeInterval)currentTime
{
    CGVector camDistanceMoved = [camera update:currentTime character:character];
    [sceneryManager update:currentTime camDelta:camDistanceMoved];
    [character update:currentTime];
    [camera update:currentTime character:character];
}

@end
