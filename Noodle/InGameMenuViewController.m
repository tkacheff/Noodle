//
//  InGameMenuViewController.m
//  Noodle
//
//  Created by Ben Tkacheff on 4/11/16.
//  Copyright © 2016 Ben Tkacheff. All rights reserved.
//

#import "InGameMenuViewController.h"

#define BLUR_ANIMATION_DURATION 0.5

@interface InGameMenuViewController ()

@end

@implementation InGameMenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

-(void) transitionResumeText:(UILabel*) label withString:(NSString*) string andTime:(float) time
{
    CATransition *animation = [CATransition animation];
    animation.duration = time/2.0f;
    animation.type = kCATransitionPush;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [label.layer addAnimation:animation forKey:@"changeTextTransition"];
    label.text = string;
}

-(void) showResumeAnimation
{
    const float timeForEachLabel = 0.4;
    
    UILabel* label = [[UILabel alloc] initWithFrame:self.view.frame];
    label.textAlignment = NSTextAlignmentCenter;
    
    [self.view addSubview:label];
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
                        //[gameScene unpauseGame];
                    });
                });
            });
        });
    });
    
}

- (IBAction) startGameTapped:(id)sender
{
    [self showResumeAnimation];
}

-(IBAction)quitButtonTapped:(id)sender
{
    //[gameScene quitGame];
    [self hide:YES];
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
    self.view.hidden = NO;
}

-(void) doHide
{
    self.view.hidden = YES;
}

-(void) hide:(BOOL) immediate
{
    [self doHide];
}

@end
