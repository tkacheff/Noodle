//
//  InGameUI.h
//  Noodle
//
//  Created by Ben Tkacheff on 3/1/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class InGameMainMenu;

@interface InGameUI : NSObject
{
    SKView* parentView;
    InGameMainMenu* mainMenu;
}

-(id) initWithView:(SKView*) view;
@end
