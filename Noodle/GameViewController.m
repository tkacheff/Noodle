//
//  ViewController.m
//  Noodle
//
//

#import "GameViewController.h"
#import "InfiniteGameScene.h"
#import "InGameMainMenu.h"

@implementation GameViewController

-(id) initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(killGame:) name:@"KillGame" object:nil];
    }
    
    return self;
}

-(void) dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
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
        
        NSString *scenePath = [[NSBundle mainBundle] pathForResource:@"Levels/InfiniteLevel" ofType:@"sks"];
        InfiniteGameScene *scene = [InfiniteGameScene unarchiveFromFile:scenePath];
        
        scene.scaleMode = SKSceneScaleModeAspectFill;

        [scene setViewController:self];
        
        [skView presentScene:scene];
    }
}

-(void) killGame:(NSNotification*) notification
{
    [self dismissViewControllerAnimated:YES completion:^{}];
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
