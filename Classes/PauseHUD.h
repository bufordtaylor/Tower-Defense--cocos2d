//
//  PauseHUD.h
//  TowerDefenseTutorial
//
//  Created by Buford Taylor on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface PauseHUD : CCLayer {
    CCSprite * pauseButton;
    CCSprite * towerSelectButton;
    BOOL isPaused;
    BOOL shouldResumeAnimation;
}

@property (nonatomic, assign) BOOL shouldResumeAnimation;

+ (PauseHUD *)sharedHUD;
-(BOOL) isPaused;
-(BOOL) shouldResumeAnimation;


@end
