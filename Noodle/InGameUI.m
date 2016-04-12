//
//  InGameUI.m
//  Noodle
//
//  Created by Ben Tkacheff on 3/1/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import "InGameUI.h"
#import "SceneBase.h"
#import "InGameMainMenu.h"

#define PAUSE_BUTTON_SIZE 32.0f

@implementation InGameUI

-(id) initWithView:(SKView*) view
{
    if (self = [super init])
    {
        parentView = view;
        
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, parentView.frame.size.height - PAUSE_BUTTON_SIZE, PAUSE_BUTTON_SIZE, PAUSE_BUTTON_SIZE)];
        button.backgroundColor = [UIColor purpleColor];
        [button addTarget:self action:@selector(pauseButtonTapped) forControlEvents:UIControlEventTouchUpInside];
        [parentView addSubview:button];
        
        mainMenu = (InGameMainMenu*)[[[NSBundle mainBundle] loadNibNamed:@"InGameMainMenu" owner:self options:nil] firstObject];
        if (mainMenu && [mainMenu isKindOfClass:[InGameMainMenu class]])
        {
            [mainMenu setupWithView:view];
        }
    }
    
    return self;
}

-(void) pauseButtonTapped
{
    SceneBase* gameScene = (SceneBase*)parentView.scene;
    [gameScene pauseGame];
    
    UIStoryboard *mainStoryboard = [UIStoryboard storyboardWithName:@"Game" bundle:nil];
    UIViewController *inGameMenu = [mainStoryboard instantiateViewControllerWithIdentifier:@"InGameMenu"];
    [[gameScene getPresentingController] presentViewController:inGameMenu animated:YES completion:^{
        NSLog(@"should have menu");
    }];
    
   // [mainMenu show];
}

@end
