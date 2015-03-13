//
//  MainMenu.h
//  Noodle
//
//  Created by Ben Tkacheff on 3/3/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Settings;

@interface MainMenu : UIVisualEffectView
{
    SKView* parentView;
    Settings* settings;
    
    UIImageView* blurredView;
}

@property IBOutlet UIButton* resumeGameButton;
@property IBOutlet UIButton* settingsButton;

-(void) setupWithView:(SKView*) view;

-(void) show;
-(void) hide;
@end
