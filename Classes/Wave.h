//
//  Wave.h
//  Cocos2D Tower Defense


#import "cocos2d.h"

#import "Creep.h"

@interface Wave : CCNode {
	float _spawnRate;
	int _totalCreeps;
	Creep * _creepType;
}

@property (nonatomic) float spawnRate;
@property (nonatomic) int totalCreeps;
@property (nonatomic, retain) Creep *creepType;

- (id)initWithCreep:(Creep *)creep SpawnRate:(float)spawnrate TotalCreeps:(int)totalcreeps;

@end
