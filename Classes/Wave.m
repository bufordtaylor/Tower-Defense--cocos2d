//
//  Wave.m
//  Cocos2D Tower Defense


#import "Wave.h"

@implementation Wave

@synthesize spawnRate = _spawnRate;
@synthesize totalCreeps = _totalCreeps;
@synthesize creepType = _creepType;

-(id) init
{
	if( (self=[super init]) ) {
		
	}
	
	return self;
}

- (id) initWithCreep:(Creep *)creep SpawnRate:(float)spawnrate TotalCreeps:(int)totalcreeps
{
	NSAssert(creep!=nil, @"Invalid creep for wave.");

	if( (self = [self init]) )
	{
		_creepType = creep;
		_spawnRate = spawnrate;
		_totalCreeps = totalcreeps;
	}
	return self;
}


@end
