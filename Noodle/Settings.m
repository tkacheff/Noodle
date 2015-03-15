//
//  Settings.m
//  Noodle
//
//  Created by Ben Tkacheff on 3/10/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import "Settings.h"
#import "SettingsStorage.h"

@interface Settings ()
-(IBAction)returnTapped:(id)sender;
-(IBAction)invertFlingSwitched:(id)sender;
@end

@implementation Settings

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        SettingsStorage* storage = [SettingsStorage sharedManager];
        self.invertControlsSwitch.on = [storage getInvertFling];
    }
    return self;
}

-(void) willMoveToSuperview:(UIView *)newSuperview
{
    self.frame = newSuperview.frame;
}

-(IBAction)returnTapped:(id)sender
{
    [self transitionOut];
}

-(void) transitionOut
{
    [UIView animateWithDuration:0.5
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.alpha = 0;
                     }
                     completion:^(BOOL finished){
                         [self removeFromSuperview];
                         [[NSNotificationCenter defaultCenter] postNotificationName:LEFT_SETTINGS_MENU object:nil];
                     }];
}

-(IBAction)invertFlingSwitched:(id)sender
{
    SettingsStorage* settingsStorage = [SettingsStorage sharedManager];
    [settingsStorage setInvertFling:[self.invertControlsSwitch isOn]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:INVERT_FLING_KEY object:nil];
}

@end
