//
//  InGameUI.m
//  Noodle
//
//  Created by Ben Tkacheff on 3/1/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import "InGameUI.h"

#define PAUSE_BUTTON_SIZE 45.0f

@implementation InGameUI

-(id) initWithSize:(CGSize)size numOfJumps:(int) numOfJumps;
{
    if (self = [super init])
    {
        NSMutableArray* tempArray = [[NSMutableArray alloc] initWithCapacity:numOfJumps];
        for (int i = 0; i < numOfJumps; ++i)
        {
            SKSpriteNode* jumpView = [[SKSpriteNode alloc] initWithColor:[UIColor purpleColor] size:CGSizeMake(32, 32)];
            [jumpView setPosition:CGPointMake(self.frame.size.width - ((i + 1) * 32), 5)];
            [tempArray addObject:jumpView];
        }
        jumps = [[NSArray alloc] initWithArray:tempArray];
        
        pauseButton = [[SKSpriteNode alloc] initWithColor:[SKColor greenColor] size:CGSizeMake(PAUSE_BUTTON_SIZE, PAUSE_BUTTON_SIZE)];
        [pauseButton setPosition:CGPointMake(-size.width/2.0f + PAUSE_BUTTON_SIZE/2.0f, size.height/2.0f - PAUSE_BUTTON_SIZE/2.0f)];
 
        [self addChild:pauseButton];
    }
    
    return self;
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event
{
    NSLog(@"touchy");
}

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event
{
    
}

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event
{
    
}

-(void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    
}
@end
