//
//  TutorialLayer.m
//  Cocos2D Tower Defense


// Import the interfaces
#import "TutorialScene.h"
#import "GameHUD.h"
#import "CCSprite.h"
#import "DataModel.h"

// Tutorial implementation
@implementation Tutorial

@synthesize tileMap = _tileMap;
@synthesize background = _background;

@synthesize currentLevel = _currentLevel;
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Tutorial *layer = [Tutorial node];
	

    
    
	// add layer as a child to scene
	[scene addChild:layer z:1];
	
	GameHUD * myGameHUD = [GameHUD sharedHUD];
	[scene addChild:myGameHUD z:2];
	
	DataModel *m = [DataModel getModel];
	m._gameLayer = layer;
	m._gameHUDLayer = myGameHUD;
    

    
    
    CCSprite* bg  = [CCSprite spriteWithFile:@"Default.png"];
    [bg setPosition:ccp(240, 160)];
    [scene addChild:bg z:0];

	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init {
    if((self = [super init])) {				
		self.tileMap = [CCTMXTiledMap tiledMapWithTMXFile:@"TileMap3.tmx"];
        self.background = [_tileMap layerNamed:@"Background"];
		self.background.anchorPoint = ccp(0, 0);
		[self addChild:_tileMap z:0];
		
		[self addWaypoint];
		[self addWaves];
		
		// Call game logic about every second
        [self schedule:@selector(update:)];
		[self schedule:@selector(gameLogic:) interval:1.0];		
		
		self.currentLevel = 0;
		
//		self.position = ccp(-228, -122);
        self.position = ccp(0,25);
		
		gameHUD = [GameHUD sharedHUD];
		
    }
    return self;
}

-(void)addWaves {
	DataModel *m = [DataModel getModel];
	
	Wave *wave = nil;
	wave = [[Wave alloc] initWithCreep:[FastRedCreep creep] SpawnRate:0.3 TotalCreeps:50];
	[m._waves addObject:wave];
	wave = nil;
	wave = [[Wave alloc] initWithCreep:[StrongGreenCreep creep] SpawnRate:1.0 TotalCreeps:10];
	[m._waves addObject:wave];
	wave = nil;	
}

- (Wave *)getCurrentWave{
	
	DataModel *m = [DataModel getModel];	
	Wave * wave = (Wave *) [m._waves objectAtIndex:self.currentLevel];
	
	return wave;
}

- (Wave *)getNextWave{
	
	DataModel *m = [DataModel getModel];
	
	self.currentLevel++;
	
	if (self.currentLevel > 1)
		self.currentLevel = 0;
	
	 Wave * wave = (Wave *) [m._waves objectAtIndex:self.currentLevel];
	 
	 return wave;
}

-(void)addWaypoint {
	DataModel *m = [DataModel getModel];
	
	CCTMXObjectGroup *objects = [self.tileMap objectGroupNamed:@"Objects"];
	WayPoint *wp = nil;
	
	int wayPointCounter = 0;
	NSMutableDictionary *wayPoint;
	while ((wayPoint = [objects objectNamed:[NSString stringWithFormat:@"Waypoint%d", wayPointCounter]])) {
		int x = [[wayPoint valueForKey:@"x"] intValue];
		int y = [[wayPoint valueForKey:@"y"] intValue];
		
		wp = [WayPoint node];
		wp.position = ccp(x, y);
		[m._waypoints addObject:wp];
		wayPointCounter++;
	}
	
	NSAssert([m._waypoints count] > 0, @"Waypoint objects missing");
    NSLog(@"Okay, we've got %d waypoints", [m._waypoints count]);
	wp = nil;
}

- (CGPoint) tileCoordForPosition:(CGPoint) position 
{
	int x = position.x / self.tileMap.tileSize.width;
	int y = ((self.tileMap.mapSize.height * self.tileMap.tileSize.height) - position.y) / self.tileMap.tileSize.height;
	
	return ccp(x,y);
}

- (BOOL) canBuildOnTilePosition:(CGPoint) pos 
{
	CGPoint towerLoc = [self tileCoordForPosition: pos];
	
	int tileGid = [self.background tileGIDAt:towerLoc];
	NSDictionary *props = [self.tileMap propertiesForGID:tileGid];
	NSString *type = [props valueForKey:@"buildable"];
	
	if([type isEqualToString: @"1"]) {
		return YES;
	}
	
	return NO;
}

-(void)addTower: (CGPoint)pos {
	DataModel *m = [DataModel getModel];
	
	Tower *target = nil;
	
	CGPoint towerLoc = [self tileCoordForPosition: pos];
	
	int tileGid = [self.background tileGIDAt:towerLoc];
	NSDictionary *props = [self.tileMap propertiesForGID:tileGid];
    NSLog(@"dict value %@", props);
	NSString *type = [props valueForKey:@"Buildable"];
	
	
	NSLog(@"Buildable: %@", type);
	if([type isEqualToString: @"1"]) {
		target = [MachineGunTower tower];
		target.position = ccp((towerLoc.x *  20) + 16, self.tileMap.contentSize.height - (towerLoc.y * 20) - 16);
		[self addChild:target z:1];
		
		target.tag = 1;
		[m._towers addObject:target];
		
	} else {
		NSLog(@"Tile Not Buildable");
	}
	
}

-(void)addTarget {
    
	DataModel *m = [DataModel getModel];
	Wave * wave = [self getCurrentWave];
	if (wave.totalCreeps < 0) {
		return; //[self getNextWave];
	}
	
	wave.totalCreeps--;
	
    Creep *target = nil;
    if ((arc4random() % 2) == 0) {
        target = [FastRedCreep creep];
    } else {
        target = [StrongGreenCreep creep];
    }	
	
	WayPoint *waypoint = [target getCurrentWaypoint ];
	target.position = waypoint.position;	
	waypoint = [target getNextWaypoint ];
	
	[self addChild:target z:1];
    
    float distance = ccpDistance(target.position,waypoint.position);
    float moveDuration = (distance*target.moveDuration)/400.0;
    id actionMove = [CCMoveTo actionWithDuration:moveDuration position:waypoint.position];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(FollowPath:)];
    [target runAction:[CCSequence actions:actionMove,actionMoveDone, nil]];
	
	// Add to targets array
	target.tag = 1;
	[m._targets addObject:target];
	
}

-(void)FollowPath:(id)sender {
    
	Creep *creep = (Creep *)sender;
    
	WayPoint * waypoint = [creep getNextWaypoint];
    
    
    float distance = ccpDistance(creep.position,waypoint.position);
    if (distance == 0) {
        return;
    }
    float moveDuration = (distance*creep.moveDuration)/400.0;
    id actionMove = [CCMoveTo actionWithDuration:moveDuration position:waypoint.position];
    id actionMoveDone = [CCCallFuncN actionWithTarget:self selector:@selector(FollowPath:)];

	[creep stopAllActions];
	[creep runAction:[CCSequence actions:actionMove, actionMoveDone, nil]];
}

-(void)gameLogic:(ccTime)dt {
	
//	DataModel *m = [DataModel getModel];
	Wave * wave = [self getCurrentWave];
	static double lastTimeTargetAdded = 0;
    double now = [[NSDate date] timeIntervalSince1970];
   if(lastTimeTargetAdded == 0 || now - lastTimeTargetAdded >= wave.spawnRate) {
        [self addTarget];
        lastTimeTargetAdded = now;
    }
	
}

- (void)update:(ccTime)dt {
    
	DataModel *m = [DataModel getModel];
	NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];

	for (Projectile *projectile in m._projectiles) {
		
		CGRect projectileRect = CGRectMake(projectile.position.x - (projectile.contentSize.width/2), 
										   projectile.position.y - (projectile.contentSize.height/2), 
										   projectile.contentSize.width, 
										   projectile.contentSize.height);
        
		NSMutableArray *targetsToDelete = [[NSMutableArray alloc] init];
		
		for (CCSprite *target in m._targets) {
			CGRect targetRect = CGRectMake(target.position.x - (target.contentSize.width/2), 
										   target.position.y - (target.contentSize.height/2), 
										   target.contentSize.width, 
										   target.contentSize.height);
            
			if (CGRectIntersectsRect(projectileRect, targetRect)) {
                
				[projectilesToDelete addObject:projectile];
				
                Creep *creep = (Creep *)target;
                creep.hp--;
				
                if (creep.hp <= 0) {
                    [targetsToDelete addObject:target];
                }
                break;
                
			}						
		}
		
		for (CCSprite *target in targetsToDelete) {
			[m._targets removeObject:target];
			[self removeChild:target cleanup:YES];									
		}
		
		[targetsToDelete release];
	}
	
	for (CCSprite *projectile in projectilesToDelete) {
		[m._projectiles removeObject:projectile];
		[self removeChild:projectile cleanup:YES];
	}
	[projectilesToDelete release];
}


- (CGPoint)boundLayerPos:(CGPoint)newPos {
    CGSize winSize = [CCDirector sharedDirector].winSize;
    
    CGPoint retval = newPos;
    retval.x = MIN(retval.x, 0);
    retval.x = MAX(retval.x, -_tileMap.contentSize.width+winSize.width); 
    retval.y = MIN(0, retval.y);
    retval.y = MAX(-_tileMap.contentSize.height+winSize.height, retval.y); 
//    NSLog(@"boundLayerPos %d", retval);
    return retval;
}

- (void)handlePanFrom:(UIPanGestureRecognizer *)recognizer {
    return;//XXX TODO 
    
    if (recognizer.state == UIGestureRecognizerStateBegan) {    
        
        CGPoint touchLocation = [recognizer locationInView:recognizer.view];
        touchLocation = [[CCDirector sharedDirector] convertToGL:touchLocation];
        touchLocation = [self convertToNodeSpace:touchLocation];                
        
    } else if (recognizer.state == UIGestureRecognizerStateChanged) {    
        
        CGPoint translation = [recognizer translationInView:recognizer.view];
        translation = ccp(translation.x, -translation.y);
        CGPoint newPos = ccpAdd(self.position, translation);
        self.position = [self boundLayerPos:newPos];  
        [recognizer setTranslation:CGPointZero inView:recognizer.view];    
        
    } else if (recognizer.state == UIGestureRecognizerStateEnded) {
               
		float scrollDuration = 0.2;
		CGPoint velocity = [recognizer velocityInView:recognizer.view];
		CGPoint newPos = ccpAdd(self.position, ccpMult(ccp(velocity.x, velocity.y * -1), scrollDuration));
		newPos = [self boundLayerPos:newPos];

		[self stopAllActions];
		CCMoveTo *moveTo = [CCMoveTo actionWithDuration:scrollDuration position:newPos];            
		[self runAction:[CCEaseOut actionWithAction:moveTo rate:1]];            
        
    }        
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[super dealloc];
}

@end
