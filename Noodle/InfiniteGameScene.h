//
//  MyScene.h
//  Noodle
//
//

#import <SpriteKit/SpriteKit.h>
#import "SceneBase.h"

@class Character;
@class Camera;

@interface InfiniteGameScene : SceneBase<SKPhysicsContactDelegate>
{
    Character *character;
    Camera *camera;
}
@end
