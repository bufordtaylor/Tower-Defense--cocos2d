//
//  TowerDefenseTutorialAppDelegate.h
//  Cocos2D Tower Defense


#import <UIKit/UIKit.h>

@class RootViewController;

@interface TowerDefenseTutorialAppDelegate : NSObject <UIApplicationDelegate> {
	UIWindow			*window;
	RootViewController	*viewController;
}

@property (nonatomic, retain) UIWindow *window;

@end
