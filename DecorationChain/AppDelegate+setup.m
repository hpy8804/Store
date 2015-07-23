//
//  AppDelegate2.m
//  DecorationChain
//
//  Created by huangxinping on 15/1/31.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "AppDelegate+setup.h"
#import <MAThemeKit/MAThemeKit.h>
#import <AFNetworking/AFNetworkReachabilityManager.h>
#import <SVProgressHUD/SVProgressHUD.h>

@implementation AppDelegate (setup)

- (void)setAppearance {
//	[MAThemeKit setupThemeWithPrimaryColor:[UIColor colorWithRed:0.801 green:0.268 blue:0.354 alpha:1.000] secondaryColor:[UIColor whiteColor] fontName:nil lightStatusBar:YES];

//	// style the navigation bar
//	UIColor *navColor = [UIColor colorWithRed:0.175f green:0.458f blue:0.831f alpha:1.0f];
//	[[UINavigationBar appearance] setBarTintColor:navColor];
	[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
	[[UINavigationBar appearance] setTitleTextAttributes:@{ NSForegroundColorAttributeName: [UIColor whiteColor] }];
//
//	// make the status bar white
//	[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
}

- (void)setURLCache {
	NSURLCache *sharedCache = [[NSURLCache alloc] initWithMemoryCapacity:2 * 1024 * 1024
	                                                        diskCapacity:100 * 1024 * 1024
	                                                            diskPath:nil];
	[NSURLCache setSharedURLCache:sharedCache];
}

- (void)setNetworkMonitor {
	static BOOL tipShow = NO;
	static AFNetworkReachabilityStatus lastNetworkStatus = AFNetworkReachabilityStatusUnknown;
	[[AFNetworkReachabilityManager sharedManager] startMonitoring];
	[[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock: ^(AFNetworkReachabilityStatus status) {
	    if (lastNetworkStatus != status && tipShow) {
	        switch (status) {
				case AFNetworkReachabilityStatusUnknown:
				case AFNetworkReachabilityStatusNotReachable:
					{
					    [SVProgressHUD showErrorWithStatus:@"网络连接丢失"];
					    break;
					}

				case AFNetworkReachabilityStatusReachableViaWWAN:
					{
					    [SVProgressHUD showInfoWithStatus:@"切换至蜂窝"];
					    break;
					}

				case AFNetworkReachabilityStatusReachableViaWiFi:
					{
					    [SVProgressHUD showInfoWithStatus:@"切换至Wi-Fi"];
					    break;
					}

				default:
					break;
			}
		}

	    lastNetworkStatus = status;
	    tipShow = YES;
	}];
}

- (void)setup {
	[self setAppearance];
	[self setURLCache];
	[self setNetworkMonitor];
}

@end
