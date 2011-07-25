//
//  ScoreHUD.h
//  TowerDefenseTutorial
//
//  Created by Buford Taylor on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cocos2d.h"

@interface ScoreHUD : CCLayer {
    CCLabelTTF* scoreBoard;
    CCLabelTTF* scoreBoard2;
    int score;
    int life;
}

+ (ScoreHUD *)sharedHUD;
-(void) updateScore:(int)kills;
-(void) updateLife:(int)pain;


@end
