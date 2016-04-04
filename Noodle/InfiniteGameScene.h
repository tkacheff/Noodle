//
//  InfiniteGameScene.h
//  Noodle
//
//

#import <SpriteKit/SpriteKit.h>
#import "SceneBase.h"

@class Character;
@class Camera;

@interface InfiniteGameScene : SceneBase<SKPhysicsContactDelegate>
{
    int highestPlatformPos;
    int generationLookAhead;
}
@end
