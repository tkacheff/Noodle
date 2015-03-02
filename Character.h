//
//  Character.h
//  Noodle
//
//  Created by Ben Tkacheff on 2/16/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface Character : SKSpriteNode
{
    float lastTimeUpdate;
    
    float maxFlingImpulseConstant;
    
    SKSpriteNode* flingLine;
    
    BOOL touchingPlatform;
    int inAirFlingRemainCount;
    float ceilingHangTime;
    
    bool isTap;
    UITouch* flingTouch;
    CGPoint initFlingPos;
}


-(id)initWithSize:(CGSize)size;

-(void) update:(CFTimeInterval)currentTime;

-(void) startFlingLine;
-(void) updateFlingLine:(CGPoint) newPos initPos:(CGPoint) initPos;
-(void) finishFlingLine:(CGPoint) newPos initPos:(CGPoint) initPos;
-(void) cancelFlingLine;

-(void) endTouchBody:(SKPhysicsBody*) otherBody contactNormal:(CGVector)contactNormal;
-(void) startTouchBody:(SKPhysicsBody*) otherBody contactNormal:(CGVector)contactNormal;

-(UITouch*)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;
-(UITouch*)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event;
-(UITouch*)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event;
-(UITouch*)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event;

@end
