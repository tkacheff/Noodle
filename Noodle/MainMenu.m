//
//  MainMenu.m
//  Noodle
//
//  Created by Ben Tkacheff on 3/3/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import "MainMenu.h"

@implementation MainMenu

-(id) initWithView:(SKView*) view
{
    if (self = [super init])
    {
        parentView = view;
        
        CGSize resumeGameButtonSize = CGSizeMake(200, 64);
        resumeGameButton = [[UIButton alloc] initWithFrame:CGRectMake(parentView.frame.size.width/2 - resumeGameButtonSize.width/2, parentView.frame.size.height/2 - resumeGameButtonSize.height/2, resumeGameButtonSize.width, resumeGameButtonSize.height)];
        resumeGameButton.backgroundColor = [UIColor purpleColor];
        [resumeGameButton setTitle:@"Start Game" forState:UIControlStateNormal];
        [resumeGameButton addTarget:self action:@selector(startGameTapped) forControlEvents:UIControlEventTouchUpInside];
        [parentView addSubview:resumeGameButton];
    }
    
    return self;
}

-(void) startGameTapped
{
    parentView.paused = false;
    [self hide];
}

-(void) show
{
    resumeGameButton.hidden = NO;
}

-(void) hide
{
    resumeGameButton.hidden = YES;
}

@end
