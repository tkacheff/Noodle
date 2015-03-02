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

@interface FirstGameScene : SKScene<SKPhysicsContactDelegate>
{
    Character *character;
    Camera *camera;
    SceneryManager* sceneryManager;
    InGameUI* ui;
    
    SKNode* world;
}

+ (instancetype)unarchiveFromFile:(NSString *)file;
- (void) setup;

@end
