//
//  SettingsViewController.m
//  Noodle
//
//  Created by Ben Tkacheff on 4/3/16.
//  Copyright © 2016 Ben Tkacheff. All rights reserved.
//

#import "SettingsViewController.h"
#import "SettingsStorage.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    SettingsStorage* storage = [SettingsStorage sharedManager];
    self.invertControlsSwitch.on = [storage getInvertFling];
    self.sensitivitySlider.value = [storage getFlingSensitivity];
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
   // dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        UIVisualEffect *blurEffect;
        blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
        UIVisualEffectView* effectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
        effectView.frame = self.view.frame;
        [self.view addSubview:effectView];
        
        [self.view bringSubviewToFront:self.invertControlsLabel];
        [self.view bringSubviewToFront:self.invertControlsSwitch];
        [self.view bringSubviewToFront:self.sensitivityLabel];
        [self.view bringSubviewToFront:self.sensitivitySlider];
        [self.view bringSubviewToFront:self.backButton];
  //  });
    
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning
{
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

- (IBAction) backTapped:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"SettingsViewControllerDismissed" object:nil userInfo:nil];
}

-(IBAction)invertFlingSwitched:(id)sender
{
    SettingsStorage* settingsStorage = [SettingsStorage sharedManager];
    [settingsStorage setInvertFling:[self.invertControlsSwitch isOn]];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:INVERT_FLING_KEY object:nil];
}


-(IBAction)flingSensitivtyChanged:(id)sender
{
    float newValue = self.sensitivitySlider.value;
    
    SettingsStorage* settingsStorage = [SettingsStorage sharedManager];
    [settingsStorage setFlingSensitivity:newValue];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:FLING_SENSITIVITY_KEY object:nil];
}

@end
