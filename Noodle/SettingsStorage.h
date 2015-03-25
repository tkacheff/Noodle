//
//  SettingsStorage.h
//  Noodle
//
//  Created by Ben Tkacheff on 3/13/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import <Foundation/Foundation.h>

#define FLING_SENSITIVITY_KEY @"NoodleFlingSensitivty"
#define INVERT_FLING_KEY @"NoodleFlingInvert"

@interface SettingsStorage : NSObject
{
    float storedFlingSenstivity;
    BOOL storedInvertFling;
}

+ (id)sharedManager;

-(void) setInvertFling:(BOOL) value;
-(void) setFlingSensitivity:(float) value;

-(BOOL) getInvertFling;
-(float) getFlingSensitivity;

@end
