//
//  PauseHUD.m
//  TowerDefenseTutorial
//
//  Created by Buford Taylor on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PauseHUD.h"
#import "DataModel.h"

@implementation PauseHUD

static PauseHUD *_sharedHUD = nil;
@synthesize shouldResumeAnimation;

+ (PauseHUD *)sharedHUD
{
	@synchronized([PauseHUD class])
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
	@synchronized([PauseHUD class])
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
        isPaused = NO;
        shouldResumeAnimation = YES;
        
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGB565];
        pauseButton = [CCSprite spriteWithFile:@"pause-red.png"];
        pauseButton.scale = 0.10f;
        [pauseButton setPosition:ccp(20, 300)];
        [self addChild:pauseButton];
        
        towerSelectButton = [CCSprite spriteWithFile:@"pause-red.png"];
        towerSelectButton.scale = 0.10f;
        [towerSelectButton setPosition:ccp(50, 300)];
        [self addChild:towerSelectButton];
        
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_Default];
        [[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:NO];
	}
	return self;
}

-(BOOL) isPaused { return isPaused; }
-(BOOL) shouldResumeAnimation { return shouldResumeAnimation; }

- (void)ccTouchEnded:(UITouch *)touch withEvent:(UIEvent *)event {  
	CGPoint touchLocation = [self convertTouchToNodeSpace:touch];
    if (CGRectContainsPoint(pauseButton.boundingBox, touchLocation)) { 
        if(isPaused){
            CCTexture2D *texture2D = [[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"pause-red.png"]];
            [pauseButton setTexture: texture2D];
            isPaused = NO;
            shouldResumeAnimation = YES;
        } else{
            CCTexture2D *texture2D = [[CCTexture2D alloc]initWithImage:[UIImage imageNamed:@"play-green.png"]];
            [pauseButton setTexture: texture2D];
            isPaused = YES;
        }
    }
    if (CGRectContainsPoint(towerSelectButton.boundingBox, touchLocation)) {
        DataModel* m = [DataModel getModel];
        [m._towerSelectHUDLayer toggleTSHUDwithSpeed:2];
        
    }
}

-(BOOL) ccTouchBegan:(UITouch *)touch withEvent:(UIEvent *)event{
    return YES;
}

- (void) registerWithTouchDispatcher
{
	[[CCTouchDispatcher sharedDispatcher] addTargetedDelegate:self priority:0 swallowsTouches:YES];
}

-(void) dealloc{
    [pauseButton release];
    [super dealloc];
}

@end
