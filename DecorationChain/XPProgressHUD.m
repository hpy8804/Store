//
//  XPProgressHUD.m
//  DecorationChain
//
//  Created by huangxinping on 4/8/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "XPProgressHUD.h"

static NSTimer *XP_timeout = nil;
@implementation XPProgressHUD

+ (void)showWithStatus:(NSString *)status {
	[[UIApplication sharedApplication] beginIgnoringInteractionEvents];
	[super showWithStatus:status];

	if (XP_timeout) {
		[XP_timeout invalidate];
		XP_timeout = nil;
	}
	XP_timeout = [NSTimer scheduledTimerWithTimeInterval:10 block: ^{
	    [XPProgressHUD dismiss];
	} repeats:NO];
}

+ (void)dismiss {
	if (XP_timeout) {
		[XP_timeout invalidate];
		XP_timeout = nil;
	}
	[super dismiss];
	[[UIApplication sharedApplication] endIgnoringInteractionEvents];
}

@end
