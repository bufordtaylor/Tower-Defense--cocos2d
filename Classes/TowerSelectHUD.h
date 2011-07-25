//
//  TowerSelectHUD.h
//  TowerDefenseTutorial
//
//  Created by Buford Taylor on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"


@interface TowerSelectHUD : CCLayer {
	CCSprite * background;
	
	CCSprite * selSpriteRange;
    CCSprite * selSprite;
    BOOL hidden;
    NSMutableArray * movableSprites;
}

+ (TowerSelectHUD *)sharedHUD;

-(void) toggleTSHUDwithSpeed:(float)speed;

@end
