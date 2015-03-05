//
//  ViewController.m
//  Noodle
//
//

#define NOODLE_DEBUG

#import "GameViewController.h"
#import "InfiniteGameScene.h"
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
        mainMenu = [[MainMenu alloc] initWithView:skView];
        
        NSString *scenePath = [[NSBundle mainBundle] pathForResource:@"Levels/FirstGameLevel" ofType:@"sks"];
        InfiniteGameScene *scene = [InfiniteGameScene unarchiveFromFile:scenePath];

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
