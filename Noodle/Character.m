//
//  Character.m
//  Noodle
//
//  Created by Ben Tkacheff on 2/16/15.
//

#import "Character.h"

#define START_DENSITY 5.0f
#define MAX_TAP_DISTANCE 4.0f

static const uint32_t characterCategory  = 0x1 << 0;  // 00000000000000000000000000000001

@implementation Character


-(id)initWithSize:(CGSize)size
{
    if (self = [super initWithColor:[UIColor orangeColor] size:CGSizeMake(35, 35)])
    {
        self.position = CGPointMake(0, 0);
        
        self.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:self.frame.size];
        self.physicsBody.restitution = 0;
        self.physicsBody.density = START_DENSITY;
        self.physicsBody.allowsRotation = false;
        self.physicsBody.friction = 1.0;
        self.physicsBody.linearDamping = 0.7f;
        
        self.physicsBody.contactTestBitMask = characterCategory;
        self.physicsBody.categoryBitMask = characterCategory;
        
        flingLine = [[SKSpriteNode alloc] initWithColor:[UIColor blackColor] size:CGSizeMake(0, 0)];
        [flingLine setZPosition:-1];
        [flingLine setAnchorPoint:CGPointMake(0.5,0)];
        
        maxFlingImpulseConstant = 32.0f;
        lastTimeUpdate = 0;
        
        ceilingHangTime = 0.1f;
        inAirFlingRemainCount = 0;
        touchingPlatform = NO;
        touchingOnSide = NO;
        
        isTap = false;
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
    if (touchingPlatform || inAirFlingRemainCount > 0)
    {
        [self addChild:flingLine];
        
        if (!touchingPlatform)
        {
            self.scene.physicsWorld.speed = 0.5;
        }
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
    [flingLine setZRotation:(-self.zRotation + newRotation - M_PI/2.0f)];
    float length = sqrt(impulse.dx * impulse.dx + impulse.dy * impulse.dy) * 0.4f;
    
    if (length <= self.frame.size.width/2.0f)
    {
        [flingLine setSize:CGSizeMake(0,0)];
    }
    else
    {
        [flingLine setSize:CGSizeMake(4, length)];
    }
}

-(void) finishFlingLine:(CGPoint) newPos initPos:(CGPoint) initPos
{
    if (!flingLine.parent && inAirFlingRemainCount <= 0)
    {
        return;
    }
    
    if (inAirFlingRemainCount > 0)
    {
        inAirFlingRemainCount--;
    }
    
    if (inAirFlingRemainCount <= 0)
    {
        self.physicsBody.velocity = CGVectorMake(0, 0);
    }
    
    [self cancelFlingLine];
    [self doFling:[self getCurrentImpulse:newPos initPos:initPos]];
}

-(void) doFling:(CGVector) impulse
{
    self.physicsBody.affectedByGravity = YES;
    [self.physicsBody applyImpulse:impulse];
}

-(void) cancelFlingLine
{
    [flingLine removeFromParent];
    [flingLine setSize:CGSizeMake(0, 0)];
    self.scene.physicsWorld.speed = 1.0;
}



/////////////////////////////////////////////////
// Physics Handling
/////////////////////////////////////////////
-(void) endTouchBody:(SKPhysicsBody*) otherBody contactNormal:(CGVector)contactNormal
{
    if (self.physicsBody.allContactedBodies.count <= 0)
    {
        self.physicsBody.affectedByGravity = YES;
        touchingPlatform = NO;
        touchingOnSide = NO;
        inAirFlingRemainCount = 1;
    }
}

-(void) startTouchBody:(SKPhysicsBody*) otherBody contactNormal:(CGVector)contactNormal
{
    if (!touchingOnSide && fabs(contactNormal.dx) >= 0.5)
    {
        [self.physicsBody applyImpulse:CGVectorMake(0, -self.scene.physicsWorld.gravity.dy)];
        touchingOnSide = YES;
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
        touchingPlatform = YES;
    }
    
}


@end

