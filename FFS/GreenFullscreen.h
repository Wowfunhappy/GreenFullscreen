#import <Cocoa/Cocoa.h>
#import "JRSwizzle.h"
@interface GFS : NSObject
+ (GFS *)sharedInstance;
- (void)swizzle;
@end
