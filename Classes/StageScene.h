//
//  StageScene.h
//  TowerDefenseTutorial
//
//  Created by Buford Taylor on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#import "Creep.h"
#import "Projectile.h"
#import "Tower.h"
#import "WayPoint.h"
#import "Wave.h"

#import "GameHUD.h"
#import "TowerSelectHUD.h"
#import "PauseHUD.h"
#import "ScoreHUD.h"

// Tutorial Layer
@interface Stage : CCLayer
{
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;	
	
	int _currentLevel;
	
	TowerSelectHUD * towerSelectHUD;
    PauseHUD* pauseHUD;
    ScoreHUD* scoreHUD;
}

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;

@property (nonatomic, assign) int currentLevel;

+ (id) scene;
- (void)addWaypoint;
- (void)addTower: (CGPoint)pos;
- (BOOL) canBuildOnTilePosition:(CGPoint) pos;

@end