//
//  TutorialLayer.h
//  Cocos2D Tower Defense



// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

#import "Creep.h"
#import "Projectile.h"
#import "Tower.h"
#import "WayPoint.h"
#import "Wave.h"

#import "GameHUD.h"

// Tutorial Layer
@interface Tutorial : CCLayer
{
    CCTMXTiledMap *_tileMap;
    CCTMXLayer *_background;	
	
	int _currentLevel;
	
	GameHUD * gameHUD;
}

@property (nonatomic, retain) CCTMXTiledMap *tileMap;
@property (nonatomic, retain) CCTMXLayer *background;

@property (nonatomic, assign) int currentLevel;

+ (id) scene;
- (void)addWaypoint;
- (void)addTower: (CGPoint)pos;
- (BOOL) canBuildOnTilePosition:(CGPoint) pos;

@end
