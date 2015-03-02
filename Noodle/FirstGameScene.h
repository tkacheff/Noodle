//
//  MyScene.h
//  Noodle
//
//

#import <SpriteKit/SpriteKit.h>

@class Character;
@class Camera;
@class SceneryManager;

@interface FirstGameScene : SKScene<SKPhysicsContactDelegate>
{
    Character *character;
    Camera *camera;
    SceneryManager* sceneryManager;
    
    SKNode* world;
}

+ (instancetype)unarchiveFromFile:(NSString *)file;
- (void) setup;

@end
