//
//  UserInputController.m
//  Noodle
//
//  Created by Ben Tkacheff on 2/24/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import "UserInputController.h"
#import "Character.h"

@implementation UserInputController


-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
    }
    
    return self;
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (flingTouch == nil)
    {
        for (UITouch* newTouch in touches)
        {
            flingTouch = newTouch;
            initFlingPos = [flingTouch locationInNode:self.scene];
            
            Character* character = (Character*) [self.scene childNodeWithName:@"World//Character"];
            if (character)
            {
                [character startFlingLine];
            }
            
            break;
        }
    }
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    for (UITouch* newTouch in touches)
    {
        if (newTouch == flingTouch)
        {
            Character* character = (Character*) [self.scene childNodeWithName:@"World//Character"];
            if (character)
            {
                [character updateFlingLine:[flingTouch locationInNode:self.scene] initPos:initFlingPos];
            }
            
            break;
        }
    }
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    for (UITouch* newTouch in touches)
    {
        if (newTouch == flingTouch)
        {
            Character* character = (Character*) [self.scene childNodeWithName:@"World//Character"];
            if (character)
            {
                [character finishFlingLine:[flingTouch locationInNode:self.scene] initPos:initFlingPos];
            }
            
            flingTouch = nil;
            break;
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch* cancelledTouch in touches)
    {
        if (cancelledTouch == flingTouch)
        {
            flingTouch = nil;
            
            Character* character = (Character*) [self.scene childNodeWithName:@"World//Character"];
            if (character)
            {
                [character cancelFlingLine];
            }
            
        }
    }
}

@end
