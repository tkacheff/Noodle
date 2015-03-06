//
//  MainMenu.m
//  Noodle
//
//  Created by Ben Tkacheff on 3/3/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import "MainMenu.h"
#import "SceneBase.h"

@implementation MainMenu

-(id) initWithView:(SKView*) view
{
    if (self = [super init])
    {
        parentView = view;
        
        CGSize buttonSize = CGSizeMake(200, 64);
        resumeGameButton = [[UIButton alloc] initWithFrame:CGRectMake(parentView.frame.size.width/2 - buttonSize.width/2, parentView.frame.size.height/2 - buttonSize.height, buttonSize.width, buttonSize.height)];
        resumeGameButton.backgroundColor = [UIColor purpleColor];
        [resumeGameButton setTitle:@"Start Game" forState:UIControlStateNormal];
        [resumeGameButton addTarget:self action:@selector(startGameTapped) forControlEvents:UIControlEventTouchUpInside];
        [parentView addSubview:resumeGameButton];
        
        settingsButton = [[UIButton alloc] initWithFrame:CGRectMake(parentView.frame.size.width/2 - buttonSize.width/2, resumeGameButton.frame.origin.y + buttonSize.height + 10, buttonSize.width, buttonSize.height)];
        settingsButton.backgroundColor = [UIColor blueColor];
        [settingsButton setTitle:@"Settings" forState:UIControlStateNormal];
        [settingsButton addTarget:self action:@selector(settingsButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [parentView addSubview:settingsButton];
    }
    
    return self;
}

-(void) startGameTapped
{
    if ([parentView.scene isKindOfClass:[SceneBase class]])
    {
        SceneBase* gameScene = (SceneBase*)parentView.scene;
        [gameScene unpauseGame];
    }
    
    [self hide];
}

-(void) settingsButtonTapped
{
    //todo: open settings xib
}

-(void) show
{
    if ([parentView.scene isKindOfClass:[SceneBase class]])
    {
        SceneBase* gameScene = (SceneBase*)parentView.scene;
        [gameScene pauseGame];
    }
    
    resumeGameButton.hidden = NO;
    settingsButton.hidden = NO;
}

-(void) hide
{
    if ([parentView.scene isKindOfClass:[SceneBase class]])
    {
        SceneBase* gameScene = (SceneBase*)parentView.scene;
        [gameScene unpauseGame];
    }
    
    resumeGameButton.hidden = YES;
    settingsButton.hidden = YES;
}

@end
