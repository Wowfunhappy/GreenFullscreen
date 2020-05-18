//
//  GFS.m
//  GFS
//
//

#import "GreenFullscreen.h"

@implementation NSWindow (GFS)

- (void)cleanUpWindow {
  [[self standardWindowButton:NSWindowFullScreenButton] setHidden:YES];
  
  NSButton *zoomButton = [self standardWindowButton:NSWindowZoomButton];
  [zoomButton setAction:@selector(wb_fullScreen)];
  if (self.collectionBehavior == NSWindowCollectionBehaviorFullScreenPrimary) {
    [zoomButton setEnabled:YES];
  }
  else {
    [zoomButton setEnabled:NO];
  }
}

- (void)wb_fullScreen {
  [self toggleFullScreen:self];
}

- (void)GFS_windowDidExitFullScreen {
  [self cleanUpWindow];
  [self GFS_windowDidExitFullScreen];
}

- (BOOL)GFS_showsFullScreenButton {
  [self cleanUpWindow];
  return false;
}

@end


@implementation NSWindowController (GFS)
  - (void)GFS_windowDidLoad {
    [self.window cleanUpWindow];
    [self GFS_windowDidLoad];
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
  
  [NSWindow jr_swizzleMethod:@selector(showsFullScreenButton) withMethod:@selector(GFS_showsFullScreenButton) error:&error];
  
  [NSWindowController jr_swizzleMethod:@selector(windowDidLoad) withMethod:@selector(GFS_windowDidLoad) error:&error];
  
  if (error) {
    NSLog(@"Unable to swizzle: %@", error);
  }
  
  NSArray *windows = [NSApp windows];
  for (NSWindow *aWindow in windows) {
    [aWindow cleanUpWindow];
  }
}

@end
