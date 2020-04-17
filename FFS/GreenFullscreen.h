//
//  FFS.h
//  FFS
//
//  Created by Evan Lucas on 7/22/15
//  Copyright (c) 2015 Evan Lucas. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "JRSwizzle.h"
@interface FFS : NSObject
+ (FFS *)sharedInstance;
- (void)swizzle;
@end
