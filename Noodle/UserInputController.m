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
    if (self.scene.view.paused)
    {
        return;
    }
    
    Character* character = (Character*) [self.scene childNodeWithName:@"World//Character"];
    if (character)
    {
        UITouch* returnTouch = [character touchesBegan:touches withEvent:event];
        if (!returnTouch)
        {
            //todo: other processing?
        }
    }
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (self.scene.view.paused)
    {
        return;
    }
    
    Character* character = (Character*) [self.scene childNodeWithName:@"World//Character"];
    if (character)
    {
        UITouch* returnTouch = [character touchesMoved:touches withEvent:event];
        if (!returnTouch)
        {
            //todo: other processing?
        }
    }
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    if (self.scene.view.paused)
    {
        return;
    }
    
    Character* character = (Character*) [self.scene childNodeWithName:@"World//Character"];
    if (character)
    {
        UITouch* returnTouch = [character touchesEnded:touches withEvent:event];
        if (!returnTouch)
        {
            //todo: other processing?
        }
    }
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.scene.view.paused)
    {
        return;
    }
    
    Character* character = (Character*) [self.scene childNodeWithName:@"World//Character"];
    if (character)
    {
        UITouch* returnTouch = [character touchesCancelled:touches withEvent:event];
        if (!returnTouch)
        {
            //todo: other processing?
        }
    }
}


@end
