//
//  FFS.m
//  FFS
//
//

#import "GreenFullscreen.h"

@implementation NSWindow (FFS)

- (void)wb_fullScreen {
  [self toggleFullScreen:self];
}

- (BOOL)FFS_showsFullScreenButton {
  
  NSButton *zoomButton = [self standardWindowButton:NSWindowZoomButton];
  
  [zoomButton setAction:@selector(wb_fullScreen)];
  
  if (self.collectionBehavior == NSWindowCollectionBehaviorFullScreenPrimary) {
    [zoomButton setEnabled:YES];
  }
  else {
    [zoomButton setEnabled:NO];
  }
  
  return NO;
}

@end

@implementation FFS
+ (void)load {
  FFS *controller = [FFS sharedInstance];
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
  [NSWindow jr_swizzleMethod:@selector(showsFullScreenButton) withMethod:@selector(FFS_showsFullScreenButton) error:&error];
  
  if (error) {
    NSLog(@"Unable to swizzle showsFullScreenButton: %@", error);
  }
  
  NSArray *windows = [NSApp windows];
  for (NSWindow *aWindow in windows) {
    [[aWindow standardWindowButton:NSWindowZoomButton] setAction:@selector(wb_fullScreen)];
    
    NSButton *fullScreenButton = [aWindow standardWindowButton:NSWindowFullScreenButton];
    [fullScreenButton setHidden:YES];
    
    NSButton *zoomButton = [aWindow standardWindowButton:NSWindowZoomButton];
    if (aWindow.collectionBehavior == NSWindowCollectionBehaviorFullScreenPrimary) {
      [zoomButton setEnabled:YES];
    }
    else {
      [zoomButton setEnabled:NO];
    }
    
  }
}

@end
