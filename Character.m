//
//  Character.m
//  Noodle
//
//  Created by Ben Tkacheff on 2/16/15.
//

#import "Character.h"

#define START_DENSITY 5.0f

static const uint32_t characterCategory  = 0x1 << 0;  // 00000000000000000000000000000001

@implementation Character

@synthesize currentForce;

-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithColor:[UIColor redColor] size:CGSizeMake(40, 40)])
    {
        self.position = CGPointMake(0, 0);
        [self setColor:[UIColor colorWithRed:1 green:0 blue:0 alpha:0.5]];
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
        self.physicsBody.restitution = 0;
        self.physicsBody.density = START_DENSITY;
        self.physicsBody.allowsRotation = false;
        
        self.physicsBody.contactTestBitMask = characterCategory;
        self.physicsBody.categoryBitMask = characterCategory;
        
        self.userInteractionEnabled = true;
        
        flingLine = [[SKSpriteNode alloc] initWithColor:[UIColor blackColor] size:CGSizeMake(0, 0)];
        [flingLine setZPosition:-1];
        [flingLine setAnchorPoint:CGPointMake(0.5,0)];
        
        maxImpulseForce = self.physicsBody.density * 70.0f;
        lastTimeUpdate = 0;
        
        inAirFlingCount = 0;
        touchingPlatform = NO;
        
        state = MovementStateGrounded;
    }
    
    return self;
}

-(void) update:(CFTimeInterval)currentTime
{
    if (lastTimeUpdate == 0)
    {
        lastTimeUpdate = currentTime;
        return;
    }
    
    if (currentTime - lastForceUpdateTime < 0.3f)
    {
        state = MovementStateWallSlide;
        [self.physicsBody applyForce:currentForce];
    }
    else
    {
        if (self.physicsBody.velocity.dy > 0)
        {
            state = MovementStateInAir;
        }
        else if(self.physicsBody.velocity.dy < 0)
        {
            state = MovementStateGroundPound;
        }
        else
        {
            state = MovementStateGrounded;
        }
    }
    
    lastTimeUpdate = currentTime;
}

-(void) setCurrentForce:(CGVector)newForce
{
    lastForceUpdateTime = lastTimeUpdate;
    currentForce = newForce;
    
    if (currentForce.dy != 0 && currentForce.dx != 0)
    {
        [self.physicsBody applyForce:currentForce];
    }
}

-(CGVector) getCurrentImpulse:(CGPoint) newPos initPos:(CGPoint) initPos
{
    CGVector impulse = CGVectorMake( (newPos.x - initPos.x) * self.physicsBody.density, (newPos.y - initPos.y) * self.physicsBody.density);
    
    float length = sqrt(impulse.dx * impulse.dx + impulse.dy * impulse.dy);
    if (length > maxImpulseForce)
    {
        float percentage = maxImpulseForce/length;
        impulse = CGVectorMake(impulse.dx * percentage, impulse.dy * percentage);
    }
    
    return impulse;
}

-(void) startFlingLine
{
    if (touchingPlatform || inAirFlingCount > 0)
    {
        [self addChild:flingLine];
    }
}

-(void) updateFlingLine:(CGPoint) newPos initPos:(CGPoint) initPos
{
    if (!flingLine.parent)
    {
        [self cancelFlingLine];
        return;
    }
    
    CGVector impulse = [self getCurrentImpulse:newPos initPos:initPos];
    
    
    float newRotation = fmod(M_PI * 2.f - atan2(impulse.dx, impulse.dy) + M_PI_2, M_PI * 2.f);
    [flingLine setZRotation:(newRotation - M_PI/2.0f)];
    float length = sqrt(impulse.dx * impulse.dx + impulse.dy * impulse.dy);
    
    [flingLine setSize:CGSizeMake(4, length * 0.4f)];
}

-(void) finishFlingLine:(CGPoint) newPos initPos:(CGPoint) initPos
{
    if (!flingLine.parent && inAirFlingCount <= 0)
    {
        return;
    }
    
    if (inAirFlingCount > 0)
    {
        inAirFlingCount--;
    }
    
    [self cancelFlingLine];
    CGVector impulse = [self getCurrentImpulse:newPos initPos:initPos];
    self.physicsBody.affectedByGravity = YES;
    [self.physicsBody applyImpulse:impulse];
}

-(void) cancelFlingLine
{
    [flingLine removeFromParent];
    [flingLine setSize:CGSizeMake(0, 0)];
}

-(void) endTouchBody:(SKPhysicsBody*) otherBody contactNormal:(CGVector)contactNormal
{
    if (self.physicsBody.allContactedBodies.count <= 0)
    {
        self.physicsBody.affectedByGravity = YES;
        touchingPlatform = NO;
        inAirFlingCount = 1;
    }
}

-(void) startTouchBody:(SKPhysicsBody*) otherBody contactNormal:(CGVector)contactNormal
{
    if (!touchingPlatform && fabs(contactNormal.dx) >= 0.8 && self.physicsBody.velocity.dy > 0.0f)
    {
        inAirFlingCount = 0;
        [self.physicsBody applyImpulse:CGVectorMake(0, 10.0f * self.physicsBody.density + (self.physicsBody.velocity.dy/7.0f))];
    }
    
    if (contactNormal.dy <= -0.8)
    {
        self.physicsBody.affectedByGravity = NO;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.physicsBody.affectedByGravity = YES;
        });
    }
    
    touchingPlatform = YES;
}


@end

