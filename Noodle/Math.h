//
//  Math.h
//  Noodle
//
//  Created by Ben Tkacheff on 9/27/15.
//  Copyright © 2015 Ben Tkacheff. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Math : NSObject
{
}

+(CGVector) mutiplyVector:(CGVector) vectorA byConstant:(float) constant;
+(CGVector) mutiplyVectors:(CGVector) vectorA otherVector:(CGVector) vectorB;
+(CGVector) subtractVector:(CGVector) subtractVector fromVector:(CGVector) fromVector;
+(CGVector) divideVector:(CGVector) divideVector byVector:(CGVector) byVector;
+(float) dotProduct:(CGVector) vectorA otherVector:(CGVector) vectorB;

@end