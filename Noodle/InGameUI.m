//
//  InGameUI.m
//  Noodle
//
//  Created by Ben Tkacheff on 3/1/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import "InGameUI.h"
#import "SceneBase.h"
#import "MainMenu.h"

#define PAUSE_BUTTON_SIZE 32.0f

@implementation InGameUI

-(id) initWithView:(SKView*) view
{
    if (self = [super init])
    {
        parentView = view;
        
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, parentView.frame.size.height - PAUSE_BUTTON_SIZE, PAUSE_BUTTON_SIZE, PAUSE_BUTTON_SIZE)];
        button.backgroundColor = [UIColor blueColor];
        [button addTarget:self action:@selector(pauseButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [parentView addSubview:button];
        
        mainMenu = (MainMenu*)[[[NSBundle mainBundle] loadNibNamed:@"MainMenu" owner:self options:nil] firstObject];
        if (mainMenu && [mainMenu isKindOfClass:[MainMenu class]])
        {
            [mainMenu setupWithView:view];
        }
    }
    
    return self;
}

-(void) pauseButtonTapped
{
    [mainMenu show];
}

@end
