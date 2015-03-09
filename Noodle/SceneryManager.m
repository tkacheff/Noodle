//
//  SceneryManager.m
//  Noodle
//
//  Created by Ben Tkacheff on 2/23/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import "SceneryManager.h"

#define BACKGROUND_SPEED 1.0f

@implementation SceneryManager


-(void) update:(CFTimeInterval)currentTime camDelta:(CGVector) camDelta
{
    if (currentTime == 0)
    {
        return;
    }
    
    for (SKSpriteNode* node in self.children)
    {
        float scaleSpeed = node.zPosition * -BACKGROUND_SPEED;
        [node setPosition:CGPointMake(node.position.x + (camDelta.dx * scaleSpeed), node.position.y + (camDelta.dy * scaleSpeed))];
    }
}

@end
