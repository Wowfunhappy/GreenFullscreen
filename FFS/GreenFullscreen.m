//
//  GFS.m
//  GFS
//
//

#import "GreenFullscreen.h"

@implementation NSWindow (GFS)

- (void)GFS_display {
  NSButton *zoomButton = [self standardWindowButton:NSWindowZoomButton];
  [zoomButton setAction:@selector(wb_fullScreen)];
  if ([self GFS_showsFullScreenButton] == true) {
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

- (BOOL)GFS_showsFullScreenButton {
  return false;
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
  [NSWindow jr_swizzleMethod:@selector(showsFullScreenButton) withMethod:@selector(GFS_showsFullScreenButton) error:&error];
  
  if (error) {
    NSLog(@"Unable to swizzle: %@", error);
  }
  
  NSArray *windows = [NSApp windows];
  for (NSWindow *aWindow in windows) {
    [[aWindow standardWindowButton:NSWindowFullScreenButton] setHidden:YES];
  }
  
}

@end
