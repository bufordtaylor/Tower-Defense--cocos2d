//
//  GameHUD.m
//  Cocos2D Tower Defense


#import "GameHUD.h"
#import "DataModel.h"

@implementation GameHUD

static GameHUD *_sharedHUD = nil;

+ (GameHUD *)sharedHUD
{
	@synchronized([GameHUD class])
	{
		if (!_sharedHUD)
			[[self alloc] init];
		return _sharedHUD;
	}
	// to avoid compiler warning
	return nil;
}

+(id)alloc
{
	@synchronized([GameHUD class])
	{
		NSAssert(_sharedHUD == nil, @"Attempted to allocate a second instance of a singleton.");
		_sharedHUD = [super alloc];
		return _sharedHUD;
	}
	// to avoid compiler warning
	return nil;
}

-(id) init
{
	if ((self=[super init]) ) {
		
		CGSize winSize = [CCDirector sharedDirector].winSize;

        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
        background = [CCSprite spriteWithFile:@"hud.png"];
        background.anchorPoint = ccp(0,0);
        [self addChild:background];
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
		
        movableSprites = [[NSMutableArray alloc] init];
        NSArray *images = [NSArray arrayWithObjects:@"MachineGunTurret.png", @"MachineGunTurret.png", @"MachineGunTurret.png", @"MachineGunTurret.png", nil];       
        for(int i = 0; i < images.count; ++i) {
            NSString *image = [images objectAtIndex:i];
            CCSprite *sprite = [CCSprite spriteWithFile:image];
            float offsetFraction = ((float)(i+1))/(images.count+1);
            sprite.position = ccp(winSize.width*offsetFraction, 35);
            [self addChild:sprite];
            [movableSprites addObject:sprite];
        }
		[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
	}
	return self;
}

- (BOOL)ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event {  
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    CCSprite * newSprite = nil;
    for (CCSprite *sprite in movableSprites) {
        if (CGRectContainsPoint(sprite.boundingBox, touchLocation)) {  
			DataModel *m = [DataModel getModel];
			m._gestureRecognizer.enabled = NO;
			
			selSpriteRange = [CCSprite spriteWithFile:@"Range.png"];
			selSpriteRange.scale = 4;
			[self addChild:selSpriteRange z:-1];
			selSpriteRange.position = sprite.position;
			
            newSprite = [CCSprite spriteWithTexture:[sprite texture]]; //sprite;
			newSprite.position = sprite.position;
			selSprite = newSprite;
			[self addChild:newSprite];
			
            break;
        }
    }     
	return YES;
}

- (void)ccTouchMoved:(UITouch *)touch withEvent:(UIEvent *)event {  
    CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    
    CGPoint oldTouchLocation = [touch previousLocationInView:touch.view];
    oldTouchLocation = [[CCDirector sharedDirector] convertToGL:oldTouchLocation];
    oldTouchLocation = [self convertToNodeSpace:oldTouchLocation];
    
    CGPoint translation = ccpSub(touchLocation, oldTouchLocation);    
	
	if (selSprite) {
		CGPoint newPos = ccpAdd(selSprite.position, translation);
        selSprite.position = newPos;
		selSpriteRange.position = newPos;
		
		DataModel *m = [DataModel getModel];
		CGPoint touchLocationInGameLayer = [m._gameLayer convertTouchToNodeSpace:touch];
		
		BOOL isBuildable = [m._gameLayer canBuildOnTilePosition: touchLocationInGameLayer];
		if (isBuildable) {
			selSprite.opacity = 200;
		} else {
			selSprite.opacity = 50;		
		}
	}
}

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {  
	CGPoint touchLocation = [self convertTouchToNodeSpace:touch];	
	DataModel *m = [DataModel getModel];

	if (selSprite) {
		CGRect backgroundRect = CGRectMake(background.position.x, 
									   background.position.y, 
									   background.contentSize.width, 
									   background.contentSize.height);
		
		if (!CGRectContainsPoint(backgroundRect, touchLocation)) {
			CGPoint touchLocationInGameLayer = [m._gameLayer convertTouchToNodeSpace:touch];
			[m._gameLayer addTower: touchLocationInGameLayer];
		}
		
		[self removeChild:selSprite cleanup:YES];
		selSprite = nil;		
		[self removeChild:selSpriteRange cleanup:YES];
		selSpriteRange = nil;			
	}
	
	m._gestureRecognizer.enabled = YES;
}
- (void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	[movableSprites release];
    movableSprites = nil;
	[super dealloc];
}
@end
