//
//  ViewController.m
//  Noodle
//
//

#import "GameViewController.h"
#import "InfiniteGameScene.h"
#import "MainMenu.h"

@implementation GameViewController

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(gameDidPause)
                                                     name:PAUSE_GAME_NOTIFICATION
                                                   object:NULL];
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

-(void) gameDidPause
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [mainMenu show];
    });
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
