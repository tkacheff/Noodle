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
        
        zoom = 1.0f;
        alpha = 0.2;
        fSmoothY = self.position.y;
    }
    
    return self;
}

-(void) infiniteUpUpdate:(float) timeDelta character:(Character*) character
{
    float amountToMove = speed.dy * timeDelta;
    if (character.position.y > self.position.y )
    {
        const float times = (character.position.y/self.position.y) * 2.5f;
        amountToMove *= times;
    }
    
    self.position = CGPointMake(self.position.x, self.position.y + amountToMove);
}

-(void) followPlayerUpdate:(float) timeDelta character:(Character*) character
{
    const float goalDeltaY = character.position.y - self.position.y;
    float ySpeed = speed.dy;
    if (fabs(goalDeltaY) > screenSize.height/4.0f)
    {
        ySpeed *= fabs(goalDeltaY)/(screenSize.height/4.0f);
    }
    float amountToMove = goalDeltaY * ySpeed * timeDelta;
    
    fSmoothY = fSmoothY * (1-alpha) + amountToMove * alpha;
    self.position = CGPointMake(self.position.x, self.position.y + fSmoothY);
}

-(void) setZoom:(CGFloat) newZoom
{
    if (newZoom > 0.0f)
    {
        zoom = newZoom;
    }
}

-(CGVector) update:(CFTimeInterval)currentTime character:(Character*) character
{
    if (self.scene.view.paused)
    {
        lastTimeUpdate = 0;
        return CGVectorMake(0, 0);
    }
    
    if (lastTimeUpdate == 0)
    {
        lastTimeUpdate = currentTime;
        return CGVectorMake(0, 0);
    }
    
    self.scene.size = CGSizeMake(screenSize.width * zoom, screenSize.height * zoom);
    
    float timeDelta = currentTime - lastTimeUpdate;
    CGPoint lastCamPos = self.position;
    
    switch (cameraType)
    {
        case CameraTypeInfiniteUp:
            [self infiniteUpUpdate:timeDelta character:character];
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

