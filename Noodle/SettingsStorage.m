//
//  SettingsStorage.m
//  Noodle
//
//  Created by Ben Tkacheff on 3/13/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import "SettingsStorage.h"

@implementation SettingsStorage

+ (id)sharedManager
{
    static SettingsStorage *sharedMyManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

- (id)init
{
    if (self = [super init])
    {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        
        if ([prefs objectForKey:FLING_SENSITIVITY_KEY] != nil)
        {
            storedFlingSenstivity = [prefs floatForKey:FLING_SENSITIVITY_KEY];
        }
        else
        {
            storedFlingSenstivity = 1.0;
        }
        
        if ([prefs objectForKey:INVERT_FLING_KEY] != nil)
        {
            storedInvertFling = [prefs boolForKey:INVERT_FLING_KEY];
        }
        else
        {
            storedInvertFling = NO;
        }
    }
    return self;
}

-(void) saveAllPrefsToDisk
{
    [self saveFlingSensitivty];
    [self saveInvertFling];
}

-(void) saveFlingSensitivty
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setFloat:storedFlingSenstivity forKey:FLING_SENSITIVITY_KEY];
}

-(void) saveInvertFling
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    [prefs setBool:storedInvertFling forKey:INVERT_FLING_KEY];
}

-(void) setInvertFling:(BOOL) value
{
    storedInvertFling = value;
    [self saveInvertFling];
}

-(void) setFlingSensitivity:(float) value
{
    storedFlingSenstivity = value;
    [self saveFlingSensitivty];
}

-(BOOL) getInvertFling
{
    return storedInvertFling;
}
-(float) getFlingSensitivity
{
    return storedFlingSenstivity;
}

@end
