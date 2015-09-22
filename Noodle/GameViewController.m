//
//  ViewController.m
//  Noodle
//
//

#import "GameViewController.h"
#import "LevelGameScene.h"
#import "MainMenu.h"

@implementation GameViewController

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
    }
    
    return self;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    // Configure the view.
    SKView * skView = (SKView *)self.view;
    if (!skView.scene)
    {
#ifdef NOODLE_DEBUG
        skView.showsFPS = YES;
        skView.showsNodeCount = YES;
        skView.showsPhysics = YES;
#endif
        // todo: choose what level to load
        
        NSString *scenePath = [[NSBundle mainBundle] pathForResource:@"Levels/FirstGameLevel" ofType:@"sks"];
        LevelGameScene *scene = [LevelGameScene unarchiveFromFile:scenePath];
        
        scene.scaleMode = SKSceneScaleModeAspectFill;

        [skView presentScene:scene];
    }
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
