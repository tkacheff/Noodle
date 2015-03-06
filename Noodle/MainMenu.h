//
//  MainMenu.h
//  Noodle
//
//  Created by Ben Tkacheff on 3/3/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MainMenu : NSObject
{
    SKView* parentView;
    UIButton* resumeGameButton;
    UIButton* settingsButton;
}

-(id) initWithView:(SKView*) view;

-(void) show;
-(void) hide;
@end
