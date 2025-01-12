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
	ZKOrig(void);
	
	NSButton *zoomButton = [self standardWindowButton:NSWindowZoomButton];
	[zoomButton setAction:@selector(toggleFullscreen)];
	
	ZKIMP origShowsFullScreenButtonIMP = ZKOriginalImplementation(self, @selector(showsFullScreenButton), __PRETTY_FUNCTION__);
	BOOL originalShowsFullScreenButton = ((BOOL(*)(id, SEL))origShowsFullScreenButtonIMP)(self, @selector(showsFullScreenButton));
	
	if (originalShowsFullScreenButton) {
		[zoomButton setEnabled:YES];
	} else {
		[zoomButton setEnabled:NO];
	}
	
	// For apps that create NSMenus in an ususual way, namely Firefox.
	removeZoomMenuItems([[[NSApp mainMenu]itemWithTitle:NSLocalizedString(@"Window", nil)] submenu]);
}

- (void)toggleFullscreen {
	[self toggleFullScreen:self];
}

- (BOOL)showsFullScreenButton {
	return false;
}

@end




@implementation NSObject (main)

+ (void)load {
	ZKSwizzle(GFS_NSWindow, NSWindow);
	
	NSArray *windows = [NSApp windows];
	for (NSWindow *aWindow in windows) {
		[[aWindow standardWindowButton:NSWindowFullScreenButton] setHidden:YES];
	}
	
	removeZoomMenuItems([NSApp windowsMenu]);
}

@end


int main() {}