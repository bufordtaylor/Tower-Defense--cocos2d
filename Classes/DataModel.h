//
//  DataModel.h
//  Cocos2D Tower Defense


#import "cocos2d.h"

@interface DataModel : NSObject <NSCoding> {
	CCLayer *_gameLayer;
	CCLayer *_gameHUDLayer;	 //unused
    CCLayer* _towerSelectHUDLayer;
    CCLayer* _pauseHUDLayer;
    CCLayer* _scoreHUDLayer;
	
	NSMutableArray *_projectiles;
	NSMutableArray *_towers;
	NSMutableArray *_targets;	
	NSMutableArray *_waypoints;	
	
	NSMutableArray *_waves;	
	
	UIPanGestureRecognizer *_gestureRecognizer;
}

@property (nonatomic, retain) CCLayer *_gameLayer;
@property (nonatomic, retain) CCLayer *_gameHUDLayer; //unused
@property (nonatomic, retain) CCLayer *_towerSelectHUDLayer;
@property (nonatomic, retain) CCLayer *_pauseHUDLayer;
@property (nonatomic, retain) CCLayer *_scoreHUDLayer;

@property (nonatomic, retain) NSMutableArray * _projectiles;
@property (nonatomic, retain) NSMutableArray * _towers;
@property (nonatomic, retain) NSMutableArray * _targets;
@property (nonatomic, retain) NSMutableArray * _waypoints;

@property (nonatomic, retain) NSMutableArray * _waves;

@property (nonatomic, retain) UIPanGestureRecognizer *_gestureRecognizer;;
+ (DataModel*)getModel;

@end
