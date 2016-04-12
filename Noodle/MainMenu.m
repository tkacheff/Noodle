//
//  MainMenu.m
//  Noodle
//
//  Created by Ben Tkacheff on 4/2/16.
//  Copyright © 2016 Ben Tkacheff. All rights reserved.
//
#import <SpriteKit/SpriteKit.h>

#import "MainMenu.h"
#import "Settings.h"
#import "TransitionDelegate.h"
#import "InfiniteGameScene.h"

@implementation MainMenu

-(void) viewDidLoad
{
    [[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(didDismissSettingsViewController)
     name:@"SettingsViewControllerDismissed"
     object:nil];
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void) didDismissSettingsViewController
{
}

-(void) viewWillAppear:(BOOL)animated
{
    // Configure the view.
    SKView * skView = [[SKView alloc] initWithFrame:self.view.frame];
    if (!skView.scene)
    {
#ifdef NOODLE_DEBUG
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        skView.showsPhysics = YES;
#endif

        NSString *scenePath = [[NSBundle mainBundle] pathForResource:@"Levels/InfiniteLevel" ofType:@"sks"];
        InfiniteGameScene *scene = [InfiniteGameScene unarchiveFromFile:scenePath];
        
        scene.scaleMode = SKSceneScaleModeAspectFill;
        
        [skView presentScene:scene];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [scene pauseGame];
        });
        
        [self.view addSubview:skView];
        [self.view addSubview:self.settingsButton];
        [self.view addSubview:self.startButton];
    }
    
    [super viewWillAppear:animated];
}

- (IBAction) showSettings:(id)sender
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Game" bundle:nil];
    UIViewController *vc = [storyboard instantiateViewControllerWithIdentifier:@"SettingsViewController"];
    vc.view.backgroundColor = [UIColor clearColor];
    [vc setTransitioningDelegate:[[TransitionDelegate alloc] init]];
    vc.modalPresentationStyle= UIModalPresentationCustom;
    
    [self presentViewController:vc animated:YES completion:nil];
}

@end
