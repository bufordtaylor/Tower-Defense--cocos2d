//
//  Projectile.m
//  Cocos2D Tower Defense


#import "Projectile.h"

@implementation Projectile

+ (id)projectile {
	
    Projectile *projectile = nil;
    if ((projectile = [[[super alloc] initWithFile:@"Projectile.png"] autorelease])) {
		
    }
	
    return projectile;
    
}

- (void) dealloc
{  
    [super dealloc];
}

@end
