//
//  SettingsViewController.h
//  Noodle
//
//  Created by Ben Tkacheff on 4/3/16.
//  Copyright © 2016 Ben Tkacheff. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController

@property IBOutlet UILabel* invertControlsLabel;
@property IBOutlet UISwitch* invertControlsSwitch;

@property IBOutlet UILabel* sensitivityLabel;
@property IBOutlet UISlider* sensitivitySlider;

@property IBOutlet UIButton* backButton;

@end
