//
//  InGameUI.h
//  Noodle
//
//  Created by Ben Tkacheff on 3/1/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface InGameUI : SKNode
{
    NSArray* jumps;
    SKSpriteNode* pauseButton;
}

-(id) initWithSize:(CGSize)size numOfJumps:(int) numOfJumps;

@end
