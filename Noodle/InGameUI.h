//
//  InGameUI.h
//  Noodle
//
//  Created by Ben Tkacheff on 3/1/15.
//  Copyright (c) 2015 Ben Tkacheff. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@class MainMenu;

@interface InGameUI : NSObject
{
    SKView* parentView;
    MainMenu* mainMenu;
}

-(id) initWithView:(SKView*) view;
@end
