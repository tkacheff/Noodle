//
//  Character.m
//  Noodle
//
//  Created by Ben Tkacheff on 2/16/15.
//

#import "Character.h"

#define START_DENSITY 5.0f
#define MAX_TAP_DISTANCE 4.0f
#define MAX_FLING_COUNT 2
#define SLOWDOWN_SPEED 0.25f
#define NUM_OF_PROJECTIONS 17

static const uint32_t characterCategory  = 0x1 << 0;  // 00000000000000000000000000000001

@implementation Character


-(id)initWithSize:(CGSize)size position:(CGPoint) position
{
    if (self = [super initWithColor:[UIColor orangeColor] size:CGSizeMake(24, 24)])
    {
        self.position = position;
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
        self.physicsBody.restitution = 0;
        self.physicsBody.density = START_DENSITY;
        self.physicsBody.allowsRotation = false;
        self.physicsBody.friction = 1.0;
        self.physicsBody.linearDamping = 0.7f;
        
        self.physicsBody.contactTestBitMask = characterCategory;
        self.physicsBody.categoryBitMask = characterCategory;
        
        maxFlingImpulseConstant = 12.0f;
        lastTimeUpdate = 0;
        
        ceilingHangTime = 0.1f;
        flingRemainCount = MAX_FLING_COUNT;
        touchingPlatform = NO;
        sideTouchBody = nil;
        
        isTap = false;
        
        NSMutableArray* flingNodes = [[NSMutableArray alloc] init];
        for (int i = 0; i < NUM_OF_PROJECTIONS; ++i)
        {
            SKSpriteNode* sprite = [SKSpriteNode spriteNodeWithColor:[UIColor redColor] size:CGSizeMake(5, 5)];
            sprite.zPosition = -1;
            [flingNodes addObject:sprite];
        }
        flingLineNodes = [[NSArray alloc] initWithArray:flingNodes];
    }
    
    return self;
}

-(void) update:(CFTimeInterval)currentTime
{
    if (self.scene.view.paused)
    {
        flingTouch = nil;
        lastTimeUpdate = 0;
        return;
    }
    
    if (lastTimeUpdate == 0)
    {
        lastTimeUpdate = currentTime;
        return;
    }
    
    
    lastTimeUpdate = currentTime;
}


/////////////////////////////////////////////////
// Touch Handling
/////////////////////////////////////////////
-(UITouch*)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (flingTouch == nil)
    {
        for (UITouch* newTouch in touches)
        {
            isTap = true;
            flingTouch = newTouch;
            initFlingPos = [flingTouch locationInNode:self.scene];
            
            [self startFlingLine];
            return flingTouch;
        }
    }
    
    return nil;
}
-(UITouch*)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    for (UITouch* newTouch in touches)
    {
        if (newTouch == flingTouch)
        {
            CGPoint currentTouchPos = [flingTouch locationInNode:self.scene];
            if (fabs(currentTouchPos.x - initFlingPos.x) > MAX_TAP_DISTANCE ||
                fabs(currentTouchPos.y - initFlingPos.y) > MAX_TAP_DISTANCE)
            {
                isTap = false;
            }
            
            [self updateFlingLine:currentTouchPos initPos:initFlingPos];

            return flingTouch;
        }
    }
    
    return nil;
}
-(UITouch*)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    for (UITouch* newTouch in touches)
    {
        if (newTouch == flingTouch)
        {
            if (isTap)
            {
                [self cancelFlingLine];
                [self doTapContext];
            }
            else
            {
                [self finishFlingLine:[flingTouch locationInNode:self.scene] initPos:initFlingPos];
            }
            
            flingTouch = nil;
            return newTouch;
        }
    }
    
    return nil;
}
-(UITouch*)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* cancelledTouch in touches)
    {
        if (cancelledTouch == flingTouch)
        {
            flingTouch = nil;
            [self cancelFlingLine];
         
            return cancelledTouch;
        }
    }
    
    return nil;
}


/////////////////////////////////////////////////
// Tap Handling
/////////////////////////////////////////////
-(void) doTapContext
{
    self.physicsBody.velocity = CGVectorMake(0.0f, 0.0f);
    
    [self doFling:CGVectorMake(0.0f, -(maxFlingImpulseConstant * 2.0f) * self.physicsBody.density)];
}


/////////////////////////////////////////////////
// Fling Handling
/////////////////////////////////////////////

-(CGPoint) getTrajectoryPointWithInitialPosition:(CGPoint) initialPosition andImpulse:(CGVector) impulse andSteps: (CGFloat)n
{
    // Put data into correct units
    CGFloat t = 1.0 / 60.0;
    
    float biggerMass = self.physicsBody.mass * 20.0f; // magic number, idk why but it works
    CGVector initialVelocity = CGVectorMake(impulse.dx/biggerMass, impulse.dy/biggerMass);
    
    // m/s
    CGVector stepVelocity = CGVectorMake(t * initialVelocity.dx, t * initialVelocity.dy);
    
    // m/s^2
    CGVector stepGravity = CGVectorMake(t * t * self.scene.physicsWorld.gravity.dx, t * t * self.scene.physicsWorld.gravity.dy);
    
    initialPosition = CGPointMake(initialPosition.x + n * stepVelocity.dx,
                                   initialPosition.y + n * stepVelocity.dy + 0.5 * (n*n+n) * stepGravity.dy);
    
    return CGPointMake(initialPosition.x + n * stepVelocity.dx,
                        initialPosition.y + n * stepVelocity.dy + 0.5 * (n*n) * stepGravity.dy);
}

-(CGVector) getCurrentImpulse:(CGPoint) newPos initPos:(CGPoint) initPos
{
    CGVector impulse = CGVectorMake( (newPos.x - initPos.x) * self.physicsBody.density, (newPos.y - initPos.y) * self.physicsBody.density);
    
    const float length = sqrt(impulse.dx * impulse.dx + impulse.dy * impulse.dy);
    const float maxImpulseForce = maxFlingImpulseConstant * self.physicsBody.density;
    
    if (length > maxImpulseForce)
    {
        float percentage = maxImpulseForce/length;
        impulse = CGVectorMake(impulse.dx * percentage, impulse.dy * percentage);
    }
    
    return impulse;
}

-(void) startFlingLine
{
    if (touchingPlatform || flingRemainCount > 0)
    {
        if (!touchingPlatform)
        {
            self.scene.physicsWorld.speed = SLOWDOWN_SPEED;
        }
    }
}

-(void) updateFlingLine:(CGPoint) newPos initPos:(CGPoint) initPos
{
    if (flingRemainCount < 0)
    {
        [self cancelFlingLine];
        return;
    }
    
    CGVector impulse = [self getCurrentImpulse:newPos initPos:initPos];
    
    for (int i = 0; i < NUM_OF_PROJECTIONS; ++i)
    {
        CGPoint firstPoint = [self getTrajectoryPointWithInitialPosition:CGPointMake(0, 0) andImpulse:impulse andSteps:i * NUM_OF_PROJECTIONS];
        SKSpriteNode* flingSprite = (SKSpriteNode*) [flingLineNodes objectAtIndex:i];
        flingSprite.position = firstPoint;
        [flingSprite setColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:(1.0f - (float)i/NUM_OF_PROJECTIONS)]];
        if (flingSprite.parent == nil)
        {
            [self addChild:flingSprite];
        }
    }
}

-(void) finishFlingLine:(CGPoint) newPos initPos:(CGPoint) initPos
{
    if (flingRemainCount < 0)
    {
        return;
    }
    
    flingRemainCount--;
    
    [self cancelFlingLine];
    
    [self doFling:[self getCurrentImpulse:newPos initPos:initPos]];
}

-(void) doFling:(CGVector) impulse
{
    self.physicsBody.velocity = CGVectorMake(0, 0);
    self.physicsBody.affectedByGravity = YES;
    [self.physicsBody applyImpulse:impulse];
}

-(void) cancelFlingLine
{
    self.scene.physicsWorld.speed = 1.0;
    
    for (int i = 0; i < NUM_OF_PROJECTIONS; ++i)
    {
        SKSpriteNode* sprite = (SKSpriteNode*) [flingLineNodes objectAtIndex:i];
        [sprite removeFromParent];
    }
}



/////////////////////////////////////////////////
// Physics Handling
/////////////////////////////////////////////
-(void) endTouchBody:(SKPhysicsBody*) otherBody contactNormal:(CGVector)contactNormal
{
    if (sideTouchBody == otherBody && fabs(contactNormal.dx) >= 0.5)
    {
        sideTouchBody = nil;
        if (flingRemainCount > 0)
        {
            flingRemainCount--;
        }
    }
    
    if (self.physicsBody.allContactedBodies.count <= 0)
    {
        self.physicsBody.affectedByGravity = YES;
        touchingPlatform = NO;
        sideTouchBody = nil;
    }
}

-(void) startTouchBody:(SKPhysicsBody*) otherBody contactNormal:(CGVector)contactNormal
{
    if (sideTouchBody == nil && fabs(contactNormal.dx) >= 0.5)
    {
        [self.physicsBody applyImpulse:CGVectorMake(0, -self.scene.physicsWorld.gravity.dy)];
        sideTouchBody = otherBody;
        if (!touchingPlatform && flingRemainCount < MAX_FLING_COUNT)
        {
            flingRemainCount++;
        }
    }
    
    if (contactNormal.dy <= -0.8)
    {
        self.physicsBody.affectedByGravity = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(ceilingHangTime * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.physicsBody.affectedByGravity = YES;
        });
    }
    else if(contactNormal.dy >= 0.8)
    {
        if (!touchingPlatform)
        {
            self.physicsBody.velocity = CGVectorMake(0, self.physicsBody.velocity.dy);
            self.scene.physicsWorld.speed = 1.0;
        }
        flingRemainCount = 2;
        touchingPlatform = YES;
    }
    
}


@end

