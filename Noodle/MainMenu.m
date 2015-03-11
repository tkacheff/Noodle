//
//  MainMenu.m
//  Noodle
//
//  Created by Ben Tkacheff on 3/3/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import "MainMenu.h"
#import "SceneBase.h"
#import "Settings.h"

@interface MainMenu ()
-(IBAction)startGameTapped:(id)sender;
-(IBAction)settingsButtonTapped:(id)sender;
@end

@implementation MainMenu

-(void) setupWithView:(SKView*) view
{
    parentView = view;
    self.frame = parentView.frame;
    [parentView addSubview:self];
    
    UIVisualEffect *blurEffect;
    blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    
    UIVisualEffectView *visualEffectView;
    visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.alpha = 0;
    
    visualEffectView.frame = view.bounds;
    [self addSubview:visualEffectView];
    [self sendSubviewToBack:visualEffectView];
}

-(void) transitionResumeText:(UILabel*) label withString:(NSString*) string andTime:(float) time
{
    CATransition *animation = [CATransition animation];
    animation.duration = time/2.0f;
    animation.type = kCATransitionPush;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [label.layer addAnimation:animation forKey:@"changeTextTransition"];
    label.text = string;
}

-(void) showResumeAnimation:(SceneBase*) gameScene
{
    const float timeForEachLabel = 0.7;
    
    UILabel* label = [[UILabel alloc] initWithFrame:parentView.frame];
    label.textAlignment = NSTextAlignmentCenter;
    
    [parentView addSubview:label];
    [self hide];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self transitionResumeText:label withString:@"Resuming game in 3..." andTime:timeForEachLabel/2.0f];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeForEachLabel * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self transitionResumeText:label withString:@"Resuming game in 2..." andTime:timeForEachLabel/2.0f];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeForEachLabel * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self transitionResumeText:label withString:@"Resuming game in 1..." andTime:timeForEachLabel/2.0f];
                
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeForEachLabel * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [self transitionResumeText:label withString:@"" andTime:timeForEachLabel/2.0f];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(timeForEachLabel/2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [label removeFromSuperview];
                        [gameScene unpauseGame];
                    });
                });
            });
        });
    });

}

- (IBAction) startGameTapped:(id)sender
{
    if ([parentView.scene isKindOfClass:[SceneBase class]])
    {
        SceneBase* gameScene = (SceneBase*)parentView.scene;
        if (gameScene)
        {
            [self showResumeAnimation:gameScene];
        }
    }
}

-(IBAction)settingsButtonTapped:(id)sender
{
    if ([parentView.scene isKindOfClass:[SceneBase class]])
    {
        SceneBase* gameScene = (SceneBase*)parentView.scene;
        if (gameScene)
        {
            if (!settings)
            {
                settings = [[[NSBundle mainBundle] loadNibNamed:@"Settings" owner:self options:nil] firstObject];
                if (settings && [settings isKindOfClass:[Settings class]])
                {
                    [self addSubview:settings];
                }
            }
            else
            {
                [self addSubview:settings];
            }
        }
    }
}

-(void) show
{
    if ([parentView.scene isKindOfClass:[SceneBase class]])
    {
        SceneBase* gameScene = (SceneBase*)parentView.scene;
        [gameScene pauseGame];
    }
    
    self.hidden = NO;
}

-(void) hide
{
    self.hidden = YES;
}

@end
