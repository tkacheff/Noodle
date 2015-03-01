//
//  SceneryManager.m
//  Noodle
//
//  Created by Ben Tkacheff on 2/23/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import "SceneryManager.h"

@implementation SceneryManager


-(void) update:(CFTimeInterval)currentTime camDelta:(CGVector) camDelta
{
    for (SKSpriteNode* node in self.children)
    {
        float scaleSpeed = node.zPosition * -1.0f;
        [node setPosition:CGPointMake(node.position.x + (camDelta.dx * scaleSpeed), node.position.y + (camDelta.dy * scaleSpeed))];
    }
}

@end
