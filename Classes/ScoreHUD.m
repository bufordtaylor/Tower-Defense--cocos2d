//
//  ScoreHUD.m
//  TowerDefenseTutorial
//
//  Created by Buford Taylor on 7/6/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "ScoreHUD.h"

@implementation ScoreHUD

static ScoreHUD *_sharedHUD = nil;

+ (ScoreHUD *)sharedHUD
{
	@synchronized([ScoreHUD class])
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
	@synchronized([ScoreHUD class])
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
        
        CCTexture2DPixelFormat currentFormat = [CCTexture2D defaultAlphaPixelFormat];
        [CCTexture2D setDefaultAlphaPixelFormat:kCCTexture2DPixelFormat_RGBA4444];
//        scoreBoard = [[CCLabelAtlas labelWithString:@"00" charMapFile:@"fps_images.png" itemWidth:16 itemHeight:24 startCharMap:'.'] retain];
//        [scoreBoard setPosition:ccp(325, 280)];
        
        scoreBoard2 = [CCLabelTTF labelWithString:@"Kills 0" fontName:@"Arial" fontSize:16];
        [scoreBoard2 setPosition:ccp(445, 310)];
        [self addChild:scoreBoard2];
        
        scoreBoard = [CCLabelTTF labelWithString:@"Life 10" fontName:@"Arial" fontSize:16];
        [scoreBoard setPosition:ccp(445, 290)];
        [self addChild:scoreBoard];
        [CCTexture2D setDefaultAlphaPixelFormat:currentFormat];	
        score = 0;
        life = 10;
	}
	return self;
}

-(void) updateScore:(int)kills {
    score += kills;
    [scoreBoard2 setString:[NSString stringWithFormat:@"Kills %d", score]];
}
-(void) updateLife:(int)pain {
    life -= pain;
    [scoreBoard setString:[NSString stringWithFormat:@"Life %d", life]];
}


-(void) dealloc{
    [scoreBoard2 release];
    [scoreBoard release];
    [super dealloc];
}

@end


