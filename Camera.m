//
//  Camera.m
//  Noodle
//
//  Created by Ben Tkacheff on 2/16/15.
//

#import "Camera.h"
#import "Character.h"


@implementation Camera

-(id)initWithSize:(CGSize)size type:(CameraType) newCameraType
{
    if (self = [super init])
    {
        screenSize = size;
        cameraType = newCameraType;
        
        switch (cameraType)
        {
            case CameraTypeInfiniteUp: speed = CGVectorMake(0.0f, 20.0f); break;
            case CameraTypeFollowPlayer: speed = CGVectorMake(0.0f, 4.0f); break;
            default: speed = CGVectorMake(0.0f, 0.0f); break;
        }
    }
    
    return self;
}

-(void) infiniteUpUpdate:(float) timeDelta
{
    float amountToMove = speed.dy * timeDelta;
    self.position = CGPointMake(self.position.x, self.position.y + amountToMove);
}

-(void) followPlayerUpdate:(float) timeDelta character:(Character*) character
{
    float goalDeltaY = character.position.y - self.position.y;
    
    float amountToMove = goalDeltaY * speed.dy * timeDelta;
    amountToMove /= 2.0f;
    self.position = CGPointMake(self.position.x, self.position.y + amountToMove);
}

-(CGVector) update:(CFTimeInterval)currentTime character:(Character*) character
{
    NSLog(@"yeah");
    if (lastTimeUpdate == 0)
    {
        lastTimeUpdate = currentTime;
        return CGVectorMake(0, 0);
    }
    
    float timeDelta = currentTime - lastTimeUpdate;
    CGPoint lastCamPos = self.position;
    
    switch (cameraType)
    {
        case CameraTypeInfiniteUp:
            [self infiniteUpUpdate:timeDelta];
            break;
        case CameraTypeFollowPlayer:
            [self followPlayerUpdate:timeDelta character:character];
            break;
        default:
            break;
    }
    
    lastTimeUpdate = currentTime;
    return CGVectorMake(self.position.x - lastCamPos.x, self.position.y - lastCamPos.y);
}

@end

