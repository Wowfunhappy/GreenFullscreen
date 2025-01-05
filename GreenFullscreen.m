#import <AppKit/AppKit.h>
#import "ZKSwizzle.h"




void removeZoomMenuItems(NSMenu *menu) {
	for (NSString *title in @[@"Zoom", @"Zoom All"]) {
		NSInteger index = [menu indexOfItemWithTitle:title];
		if (index != -1) {
			[menu removeItemAtIndex:index];
		}
	}
}




@interface GFS_NSWindow : NSWindow
@end


@implementation GFS_NSWindow

- (void)update {
	NSButton *zoomButton = [self standardWindowButton:NSWindowZoomButton];
	[zoomButton setAction:@selector(toggleFullscreen)];
	
	ZKIMP origShowsFullScreenButtonIMP = ZKOriginalImplementation(self, @selector(showsFullScreenButton), __PRETTY_FUNCTION__);
	BOOL originalShowsFullScreenButton = ((BOOL(*)(id, SEL))origShowsFullScreenButtonIMP)(self, @selector(showsFullScreenButton));
	
	if (originalShowsFullScreenButton) {
		[zoomButton setEnabled:YES];
	} else {
		[zoomButton setEnabled:NO];
	}
	
	ZKOrig(void);
}

- (void)toggleFullscreen {
	[self toggleFullScreen:self];
}

- (BOOL)showsFullScreenButton {
	return false;
}

@end




@interface GFS_NSApplication : NSApplication
@end


@implementation GFS_NSApplication

- (void)setWindowsMenu:(NSMenu *)menu {
	ZKOrig(void, menu);
	dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
		removeZoomMenuItems(menu);
	});
}

@end




@implementation NSObject (main)

+ (void)load {
	ZKSwizzle(GFS_NSWindow, NSWindow);
	ZKSwizzle(GFS_NSApplication, NSApplication);
	
	NSArray *windows = [NSApp windows];
	for (NSWindow *aWindow in windows) {
		[[aWindow standardWindowButton:NSWindowFullScreenButton] setHidden:YES];
	}
	
	removeZoomMenuItems([NSApp windowsMenu]);
}

@end


int main() {}