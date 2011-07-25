//
//  Creep.h
//  Cocos2D Tower Defense


#import "cocos2d.h"

#import "DataModel.h"
#import "WayPoint.h"

@interface Creep : CCSprite <NSCopying> {
    int _curHp;
	int _moveDuration;
	int _inflictedDamage;
	int _curWaypoint;
    
    BOOL _causedDamage;
}

@property (nonatomic, assign) int hp;
@property (nonatomic, assign) int moveDuration;
@property (nonatomic, assign) int inflictedDamage;
@property (nonatomic, assign) int curWaypoint;
@property (nonatomic, assign) BOOL causedDamage;

- (Creep *) initWithCreep:(Creep *) copyFrom; 
- (WayPoint *)getCurrentWaypoint;
- (WayPoint *)getNextWaypoint;

@end

@interface FastRedCreep : Creep {
}
+(id)creep;
@end

@interface StrongGreenCreep : Creep {
}
+(id)creep;
@end