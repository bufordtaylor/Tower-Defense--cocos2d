//
//  Creep.m
//  Cocos2D Tower Defense


#import "DataModel.h"
#import "Creep.h"

@implementation Creep

@synthesize hp = _curHp;
@synthesize moveDuration = _moveDuration;
@synthesize inflictedDamage = _inflictedDamage;
@synthesize curWaypoint = _curWaypoint;
@synthesize causedDamage = _causedDamage;

- (id) copyWithZone:(NSZone *)zone {
	Creep *copy = [[[self class] allocWithZone:zone] initWithCreep:self];
	return copy;
}

- (Creep *) initWithCreep:(Creep *) copyFrom {
    if ((self = [[[super alloc] initWithFile:@"Enemy1.png"] autorelease])) {
        self.hp = copyFrom.hp;
        self.moveDuration = copyFrom.moveDuration;
        self.curWaypoint = copyFrom.curWaypoint;
        self.inflictedDamage = copyFrom.inflictedDamage;
        self.causedDamage = copyFrom.causedDamage;
	}
	[self retain];
	return self;
}

- (WayPoint *)getCurrentWaypoint{
	
	DataModel *m = [DataModel getModel];
	
	WayPoint *waypoint = (WayPoint *) [m._waypoints objectAtIndex:self.curWaypoint];
	
	return waypoint;
}

- (WayPoint *)getNextWaypoint{
	
	DataModel *m = [DataModel getModel];
	int lastWaypoint = m._waypoints.count;

	self.curWaypoint++;
	
	if (self.curWaypoint >= lastWaypoint) {
        self.causedDamage = YES;
		self.curWaypoint = 0;
    }
	
	WayPoint *waypoint = (WayPoint *) [m._waypoints objectAtIndex:self.curWaypoint];
	
	return waypoint;
}

-(void)creepLogic:(ccTime)dt {
	
	DataModel* m = [DataModel getModel];
    // Rotate creep to face next waypoint
    WayPoint *waypoint = [self getCurrentWaypoint ];
    
    CGPoint waypointVector = ccpSub(waypoint.position, self.position);
    CGFloat waypointAngle = ccpToAngle(waypointVector);
    CGFloat cocosAngle = CC_RADIANS_TO_DEGREES(-1 * waypointAngle);
    
    float rotateSpeed = 0.5 / M_PI; // 1/2 second to roate 180 degrees
    float rotateDuration = fabs(waypointAngle * rotateSpeed);    
    
    [self runAction:[CCSequence actions:
                     [CCRotateTo actionWithDuration:rotateDuration angle:cocosAngle],
                     nil]];		
}

@end

@implementation FastRedCreep

+ (id)creep {
 
    FastRedCreep *creep = nil;
    if ((creep = [[[super alloc] initWithFile:@"Enemy1.png"] autorelease])) {
        creep.hp = 1;
        creep.moveDuration = 1;
		creep.curWaypoint = 0;
        creep.inflictedDamage = 2;
        creep.causedDamage = NO;
    }
	
	[creep schedule:@selector(creepLogic:) interval:0.2];
	
    return creep;
}

@end

@implementation StrongGreenCreep

+ (id)creep {
    
    StrongGreenCreep *creep = nil;
    if ((creep = [[[super alloc] initWithFile:@"Enemy2.png"] autorelease])) {
        creep.hp = 1;
        creep.moveDuration = 9;
		creep.curWaypoint = 0;
        creep.inflictedDamage = 1;
        creep.causedDamage = NO;
    }
	
	[creep schedule:@selector(creepLogic:) interval:0.2];
    
	return creep;
}

@end