//
//  StageScene.m
//  TowerDefenseTutorial
//
//  Created by Buford Taylor on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "StageScene.h"

// Import the interfaces
#import "TowerSelectHUD.h"
#import "PauseHUD.h"
#import "DataModel.h"
#import "ScoreHUD.h"

// Stage implementation
@implementation Stage

@synthesize tileMap = _tileMap;
@synthesize background = _background;

@synthesize currentLevel = _currentLevel;
+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	Stage *layer = [Stage node];
	// add layer as a child to scene
	[scene addChild:layer z:1];
	
	TowerSelectHUD * myTowerSelectHUD = [TowerSelectHUD sharedHUD];
	[scene addChild:myTowerSelectHUD z:2];
    PauseHUD* myPauseHUD = [PauseHUD sharedHUD];
    [scene addChild:myPauseHUD z:3];
    ScoreHUD* myScoreHUD = [ScoreHUD sharedHUD];
    [scene addChild:myScoreHUD z:4];
	
	DataModel *m = [DataModel getModel];
	m._gameLayer = layer;
    m._pauseHUDLayer = myPauseHUD;
	m._towerSelectHUDLayer = myTowerSelectHUD;
    m._scoreHUDLayer = myScoreHUD;

	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init {
    if((self = [super init])) {				
        
        CCSprite* bg  = [CCSprite spriteWithFile:@"Default.png"];
        [bg setPosition:ccp(240, 160)];
        [self addChild:bg z:0];
        
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
		
		towerSelectHUD = [TowerSelectHUD sharedHUD];
        pauseHUD = [PauseHUD sharedHUD];
        scoreHUD = [ScoreHUD sharedHUD];
		
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
	NSString *type = [props valueForKey:@"Buildable"];
	
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

-(void)CreepPath:(Creep*) creep {
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

-(void)FollowPath:(id)sender {
    Creep *creep = (Creep *)sender;
    [self CreepPath:creep];
}

-(void)gameLogic:(ccTime)dt {
    Wave * wave = [self getCurrentWave];
    static double lastTimeTargetAdded = 0;
    double now = [[NSDate date] timeIntervalSince1970];
    if(lastTimeTargetAdded == 0 || now - lastTimeTargetAdded >= wave.spawnRate) {
        [self addTarget];
        lastTimeTargetAdded = now;
    }	
}

- (void)update:(ccTime)dt {
    DataModel* m = [DataModel getModel];
    PauseHUD* pm = (PauseHUD*)m._pauseHUDLayer;
    if ([pm isPaused] && [pm shouldResumeAnimation]) {
        return;
    } else if ([pm isPaused]){
		[self unschedule:@selector(gameLogic:)];
        for(CCSprite* p in m._projectiles){
            NSLog(@"p");
//            [m._projectiles removeObject:p];
//            [self removeChild:p cleanup:YES];
            [p stopAllActions];
        }
        for(Creep* c in m._targets){
            NSLog(@"c");
            [c stopAllActions];
            [c unschedule:@selector(FollowPath:)];
        }
        for(Tower* t in m._towers){
            NSLog(@"t");
            [t stopAllActions];
            [t unschedule:@selector(TowerLogic:)];
        }
        return;
    } else if (![pm isPaused] && [pm shouldResumeAnimation]){
		pm.shouldResumeAnimation  = NO;
        for(Creep* creep in m._targets){
            creep.curWaypoint--;
            [self CreepPath:creep];
            NSLog(@"c2");
        }
        for (Tower* t in m._towers) {
            NSLog(@"t2");
            [t toggleTowerAnimation];
        }
        [self schedule:@selector(gameLogic:) interval:1.0];
        return;
    }
	NSMutableArray *projectilesToDelete = [[NSMutableArray alloc] init];
    
	for (Projectile *projectile in m._projectiles) {
        NSLog(@"p2");
		
		CGRect projectileRect = CGRectMake(projectile.position.x - (projectile.contentSize.width/2), 
										   projectile.position.y - (projectile.contentSize.height/2), 
										   projectile.contentSize.width, 
										   projectile.contentSize.height);
        
		NSMutableArray *targetsToDelete = [[NSMutableArray alloc] init];
        int pain = 0;
        int kills = 0;
		
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
                    kills++;
                }
                break;
                
			}	
            
            Creep* creep = (Creep*)target;
            if(creep.causedDamage) {
                pain += creep.inflictedDamage;
                [targetsToDelete addObject:target];
                break;
            }
		}
        [m._scoreHUDLayer updateScore:kills];
        [m._scoreHUDLayer updateLife:pain];
		
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

