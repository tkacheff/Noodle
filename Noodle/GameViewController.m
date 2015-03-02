//
//  ViewController.m
//  Noodle
//
//

#define NOODLE_DEBUG

#import "GameViewController.h"
#import "FirstGameScene.h"
#import "UserInputController.h"

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
  //      skView.showsPhysics = YES;
#endif
        
        NSString *scenePath = [[NSBundle mainBundle] pathForResource:@"Levels/FirstGameLevel" ofType:@"sks"];
        FirstGameScene *scene = [FirstGameScene unarchiveFromFile:scenePath];
        [scene setup];
        
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

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

@end
