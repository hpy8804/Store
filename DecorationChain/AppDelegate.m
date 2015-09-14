//
//  AppDelegate.m
//  DecorationChain
//
//  Created by huangxinping on 15/1/14.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "AppDelegate.h"
#import "AppDelegate+setup.h"
#import "ProfileModel.h"
#import <AlipaySDK/AlipaySDK.h>
#import "base64.h"
#import "RSADataSigner.h"
#import <PgySDK/PgyManager.h>

@interface AppDelegate ()
{
}
@end

@implementation AppDelegate

static BOOL isRunningTests(void) __attribute__((const));

static BOOL isRunningTests(void) {
	NSDictionary *environment = [[NSProcessInfo processInfo] environment];
	NSString *injectBundle = environment[@"XCInjectBundle"];
	return [[injectBundle pathExtension] isEqualToString:@"octest"];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	if (isRunningTests()) {
		return YES;
	}

    [[PgyManager sharedPgyManager] startManagerWithAppId:@"55af5d8c363fa24b10c227bc61dc220c"];
    [[PgyManager sharedPgyManager] checkUpdate];
	[[ProfileModel singleton] readFromLocal];
	[self setup];
	return YES;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
	//如果极简SDK不可用，会跳转支付宝钱包进行支付，需要将支付宝钱包的支付结果回传给SDK
	if ([url.host isEqualToString:@"safepay"]) {
		[[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback: ^(NSDictionary *resultDic) {
		    NSLog(@"result = %@", resultDic);
		    NSString *statues = resultDic[@"resultStatus"];
		    if ([statues isEqualToString:@"9000"]) {
		        [XPToast showWithText:@"支付成功"];
			}
		    else {
		        [XPToast showWithText:@"支付失败"];
			}
		}];
	}
	if ([url.host isEqualToString:@"platformapi"]) {//支付宝钱包快登授权返回authCode
		[[AlipaySDK defaultService] processAuthResult:url standbyCallback: ^(NSDictionary *resultDic) {
		    NSLog(@"result = %@", resultDic);
		    NSString *statues = resultDic[@"resultStatus"];
		    if ([statues isEqualToString:@"9000"]) {
		        [XPToast showWithText:@"支付成功"];
			}
		    else {
		        [XPToast showWithText:@"支付失败"];
			}
		}];
	}

	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"province_name"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"city_name"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"district_name"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"province_id"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"city_id"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"district_id"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zipcode"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
}

- (void)applicationWillTerminate:(UIApplication *)application {
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"province_name"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"city_name"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"district_name"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"province_id"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"city_id"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"district_id"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zipcode"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

@end
