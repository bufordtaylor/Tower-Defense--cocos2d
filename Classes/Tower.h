//
//  Creep.h
//  Cocos2D Tower Defense


#import "cocos2d.h"
#import "Creep.h"
#import "SimpleAudioEngine.h"
#import "Projectile.h"
#import "DataModel.h"

@interface Tower : CCSprite {
	int _range;
    float _speed;
	
	Creep * _target;
	
	CCSprite * selSpriteRange;
	
	NSMutableArray *_projectiles;
	CCSprite *_nextProjectile;
}

@property (nonatomic, assign) int range;
@property (nonatomic, assign) float speed;
@property (nonatomic, retain) CCSprite * nextProjectile;
@property (nonatomic, retain) Creep * target;

- (Creep *)getClosestTarget;

@end

@interface MachineGunTower : Tower {

}

+ (id)tower;

- (void)setClosestTarget:(Creep *)closestTarget;
- (void)towerLogic:(ccTime)dt;
- (void)creepMoveFinished:(id)sender;
- (void)finishFiring;

@end
