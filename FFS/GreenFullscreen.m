//
//  GFS.m
//  GFS
//
//

#import "GreenFullscreen.h"

@implementation NSWindow (GFS)

- (void)GFS_display {
  [[self standardWindowButton:NSWindowFullScreenButton] setHidden:YES];
  
  NSButton *zoomButton = [self standardWindowButton:NSWindowZoomButton];
  [zoomButton setAction:@selector(wb_fullScreen)];
  if (self.collectionBehavior == NSWindowCollectionBehaviorFullScreenPrimary) {
    [zoomButton setEnabled:YES];
  }
  else {
    [zoomButton setEnabled:NO];
  }
  [self GFS_display];
}

- (void)wb_fullScreen {
  [self toggleFullScreen:self];
}

@end

@implementation GFS
+ (void)load {
  GFS *controller = [GFS sharedInstance];
  [controller swizzle];
}

+ (instancetype)sharedInstance {
  static id plugin = nil;
  if (plugin == nil) {
    plugin = [[self alloc] init];
  }
  
  return plugin;
}

- (void)swizzle {
  NSError *error = nil;
  
  [NSWindow jr_swizzleMethod:@selector(update) withMethod:@selector(GFS_display) error:&error];
  
  if (error) {
    NSLog(@"Unable to swizzle: %@", error);
  }
}

@end
