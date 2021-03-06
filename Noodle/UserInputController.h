//
//  UserInputController.h
//  Noodle
//
//  Created by Ben Tkacheff on 2/24/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface UserInputController : SKView
{
    float lastTimeUpdate;
}

-(void)touchesBegan:(NSSet*)touches withEvent:(UIEvent*)event;

-(void)touchesMoved:(NSSet*)touches withEvent:(UIEvent*)event;

-(void)touchesEnded:(NSSet*)touches withEvent:(UIEvent*)event;

@end
