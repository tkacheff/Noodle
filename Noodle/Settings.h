//
//  Settings.h
//  Noodle
//
//  Created by Ben Tkacheff on 3/10/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import <UIKit/UIKit.h>

#define LEFT_SETTINGS_MENU @"NoodleLeftSettingsMenu"

@interface Settings : UIView

@property IBOutlet UILabel* invertControlsLabel;
@property IBOutlet UISwitch* invertControlsSwitch;

@property IBOutlet UILabel* sensitivityLabel;
@property IBOutlet UISlider* sensitivitySlider;

@property IBOutlet UIButton* returnButton;

@end
