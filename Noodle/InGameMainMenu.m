//
//  MainMenu.m
//  Noodle
//
//  Created by Ben Tkacheff on 3/3/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import "InGameMainMenu.h"
#import "SceneBase.h"
#import "Settings.h"

#define BLUR_ANIMATION_DURATION 0.5

@interface InGameMainMenu ()
-(IBAction)startGameTapped:(id)sender;
-(IBAction)settingsButtonTapped:(id)sender;
@end

@implementation InGameMainMenu

-(void) setupWithView:(SKView*) view
{
    self.hidden = true;
    parentView = view;
    self.frame = parentView.frame;
    [parentView addSubview:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(settingsMenuClosed:)
                                                 name:LEFT_SETTINGS_MENU
                                               object:nil];
}

-(void) blurGameScreen
{
    self.hidden = YES;
    // Take screenshot
    UIGraphicsBeginImageContextWithOptions(parentView.bounds.size, NO, 1);
    [parentView drawViewHierarchyInRect:parentView.bounds afterScreenUpdates:YES];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    self.hidden = NO;
    
    // Blur screenshot
    CIFilter *gaussianBlurFilter = [CIFilter filterWithName:@"CIGaussianBlur"];
    [gaussianBlurFilter setDefaults];
    [gaussianBlurFilter setValue:[CIImage imageWithCGImage:[viewImage CGImage]] forKey:kCIInputImageKey];
    [gaussianBlurFilter setValue:@5 forKey:kCIInputRadiusKey];
    
    CIImage *outputImage = [gaussianBlurFilter outputImage];
    CIContext *context   = [CIContext contextWithOptions:nil];
    
    CGImageRef cgimg     = [context createCGImage:outputImage fromRect:self.frame];
    UIImage *blurredImage       = [UIImage imageWithCGImage:cgimg];
    CGImageRelease(cgimg);
    
    // Add blurred screenshot to scene
    blurredView = [[UIImageView alloc] initWithImage:blurredImage];
    CGRect thisRect = self.frame;
    blurredView.frame = thisRect;
    blurredView.alpha = 0.0f;
    
    if (blurredView.superview != self)
    {
        [self addSubview:blurredView];
        [self sendSubviewToBack:blurredView];
    }
    
    [UIView animateWithDuration:BLUR_ANIMATION_DURATION
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         blurredView.alpha = 1.0f;
    }
                     completion:nil];
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
    const float timeForEachLabel = 0.4;
    
    UILabel* label = [[UILabel alloc] initWithFrame:parentView.frame];
    label.textAlignment = NSTextAlignmentCenter;
    
    [parentView addSubview:label];
    [self hide:NO];
    
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
    [self transitionToSettings];
}

-(IBAction)quitButtonTapped:(id)sender
{
    if ([parentView.scene isKindOfClass:[SceneBase class]])
    {
        SceneBase* gameScene = (SceneBase*)parentView.scene;
        if (gameScene)
        {
            [self hide:YES];
            [gameScene quitGame];
        }
    }
}

-(void) transitionToSettings
{
    if (!settings)
    {
        settings = [[[NSBundle mainBundle] loadNibNamed:@"Settings" owner:self options:nil] firstObject];
    }
    
    if (settings && [settings isKindOfClass:[Settings class]])
    {
        settings.alpha = 0;
        [self addSubview:settings];
        
        [UIView animateWithDuration:0.1
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.resumeGameButton.alpha = 0;
                             self.settingsButton.alpha = 0;
                             self.quitGameButton.alpha = 0;
                         }
                         completion:^(BOOL finished){
                             [UIView animateWithDuration:0.5 animations:^{
                                 settings.alpha = 1;
                             }];
        }];
    }
}

-(void) settingsMenuClosed:(NSNotification*) note
{
    [UIView animateWithDuration:0.5
            delay:0.0
            options:UIViewAnimationOptionCurveEaseIn
            animations:^{
                self.resumeGameButton.alpha = 1;
                self.settingsButton.alpha = 1;
                self.quitGameButton.alpha = 1;
            }
            completion:nil];
}

-(void) show
{
    SceneBase* gameScene = (SceneBase*)parentView.scene;
    [gameScene pauseGame];
    
    self.hidden = NO;
    
    dispatch_async(dispatch_get_main_queue(), ^(void){
        [self blurGameScreen];
    });
}

-(void) doHide
{
    self.hidden = YES;
    [blurredView removeFromSuperview];
}

-(void) hide:(BOOL) immediate
{
    if (immediate)
    {
        [self doHide];
    }
    else
    {
        [UIView animateWithDuration:BLUR_ANIMATION_DURATION
                              delay:0.0
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             blurredView.alpha = 0.0;
                         }
                         completion:^(BOOL completed)
         {
             [self doHide];
         }];
    }
}

@end
