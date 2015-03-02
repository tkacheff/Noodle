//
//  Camera.h
//  Noodle
//
//  Created by Ben Tkacheff on 2/16/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class Character;

typedef NS_ENUM(NSInteger, CameraType) {
    CameraTypeFollowPlayer,
    CameraTypeInfiniteUp
};

@interface Camera : SKNode
{
    CameraType cameraType;
    float lastTimeUpdate;
    
    CGSize screenSize;
    CGVector speed;
}

-(id)initWithSize:(CGSize)size type:(CameraType) cameraType;

-(CGVector) update:(CFTimeInterval)currentTime character:(Character*) character;

@end
