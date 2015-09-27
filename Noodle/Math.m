//
//  Math.m
//  Noodle
//
//  Created by Ben Tkacheff on 9/27/15.
//  Copyright © 2015 Ben Tkacheff. All rights reserved.
//

#import "Math.h"

@implementation Math

+(CGVector) mutiplyVector:(CGVector) vectorA byConstant:(float) constant
{
    return CGVectorMake(vectorA.dx * constant, vectorA.dy * constant);
}

+(CGVector) mutiplyVectors:(CGVector) vectorA otherVector:(CGVector) vectorB
{
    return CGVectorMake(vectorA.dx * vectorB.dx, vectorA.dy * vectorB.dy);
}

+(CGVector) subtractVector:(CGVector) subtractVector fromVector:(CGVector) fromVector
{
    return CGVectorMake(fromVector.dx - subtractVector.dx, fromVector.dy - subtractVector.dy);
}

+(CGVector) divideVector:(CGVector) divideVector byVector:(CGVector) byVector
{
    return CGVectorMake(divideVector.dx / byVector.dx, divideVector.dy / byVector.dy);
}

+(float) dotProduct:(CGVector) vectorA otherVector:(CGVector) vectorB
{
    return (vectorA.dx * vectorB.dx) + (vectorA.dy * vectorB.dy);
}

@end
