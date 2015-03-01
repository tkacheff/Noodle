//
//  Character.h
//  Noodle
//
//  Created by Ben Tkacheff on 2/16/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

typedef NS_ENUM(NSInteger, MovementState) {
    MovementStateGrounded,
    MovementStateWallSlide,
    MovementStateInAir,
    MovementStateGroundPound
};

@interface Character : SKSpriteNode
{
    float lastTimeUpdate;
    float lastForceUpdateTime;
    
    CGVector currentForce;
    float maxImpulseForce;
    
    SKSpriteNode* flingLine;
    
    BOOL touchingPlatform;
    int inAirFlingCount;
    
    MovementState state;
}

@property (nonatomic) CGVector currentForce;

-(id)initWithSize:(CGSize)size;

-(void) update:(CFTimeInterval)currentTime;

-(void) setCurrentForce:(CGVector)currentForce;

-(void) startFlingLine;
-(void) updateFlingLine:(CGPoint) newPos initPos:(CGPoint) initPos;
-(void) finishFlingLine:(CGPoint) newPos initPos:(CGPoint) initPos;
-(void) cancelFlingLine;

-(void) endTouchBody:(SKPhysicsBody*) otherBody contactNormal:(CGVector)contactNormal;
-(void) startTouchBody:(SKPhysicsBody*) otherBody contactNormal:(CGVector)contactNormal;

@end
