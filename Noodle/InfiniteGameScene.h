//
//  MyScene.h
//  Noodle
//
//

#import <SpriteKit/SpriteKit.h>

@class Character;
@class Camera;
@class SceneryManager;
@class InGameUI;

@interface InfiniteGameScene : SKScene<SKPhysicsContactDelegate>
{
    Character *character;
    Camera *camera;
    SceneryManager* sceneryManager;
    InGameUI* ui;
    
    SKNode* world;
    
    BOOL isPaused;
}

+ (instancetype)unarchiveFromFile:(NSString *)file;
- (void) setup;

-(void)pauseGame;
-(void)unpauseGame;
@end
