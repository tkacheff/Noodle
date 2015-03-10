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
        dispatch_async(dispatch_get_main_queue(), ^{
            UILabel* label = [[UILabel alloc] initWithFrame:parentView.frame];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = @"Resuming game in 3...";
            [parentView addSubview:label];
            [self hide];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                CATransition *animation = [CATransition animation];
                animation.duration = 1.0;
                animation.beginTime = CACurrentMediaTime();
                animation.type = kCATransitionFade;
                animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
                [label.layer addAnimation:animation forKey:@"changeTextTransition"];
                label.text = @"Resuming game in 2...";
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    CATransition *animation2 = [CATransition animation];
                    animation2.duration = 1.0;
                    animation2.beginTime = CACurrentMediaTime();
                    animation2.type = kCATransitionFade;
                    animation2.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
                    [label.layer addAnimation:animation2 forKey:@"kCATransitionFade2"];
                    label.text = @"Resuming game in 1...";
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [label removeFromSuperview];
                        [gameScene unpauseGame];
                    });
                });
            });
            
            /**/
            // Change the text
        });
    }
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
    resumeGameButton.hidden = YES;
    settingsButton.hidden = YES;
}

@end
