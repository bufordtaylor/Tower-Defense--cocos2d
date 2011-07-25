//
//  GameHUD.h
//  Cocos2D Tower Defense


#import "cocos2d.h"


@interface GameHUD : CCLayer {
	CCSprite * background;
	
	CCSprite * selSpriteRange;
    CCSprite * selSprite;
    NSMutableArray * movableSprites;
}

+ (GameHUD *)sharedHUD;

@end
