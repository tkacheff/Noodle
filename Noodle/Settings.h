//
//  Settings.h
//  Noodle
//
//  Created by Ben Tkacheff on 3/10/15.
//  Copyright (c) 2015 Barbara Köhler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Settings : UIView

@property IBOutlet UILabel* invertControlsLabel;
@property IBOutlet UISwitch* invertControlsSwitch;

@property IBOutlet UILabel* sensitivityLabel;
@property IBOutlet UISlider* sensitivitySlider;

@end
