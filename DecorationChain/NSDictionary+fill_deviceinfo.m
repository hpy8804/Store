//
//  fill_deviceinfo.m
//  DecorationChain
//
//  Created by huangxinping on 4/7/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "NSDictionary+fill_deviceinfo.h"
#import <XPKit/XPKit.h>
#import <FCUUID/FCUUID.h>

@implementation NSDictionary (fill_deviceinfo)


- (NSDictionary *)fillDeviceInfo {
	printf("-------开始组装参数-------\n");
	NSLog(@"%@", self);
	NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
	NSMutableDictionary *buffer = [NSMutableDictionary dictionaryWithDictionary:self];
	[buffer setObject:@"ios" forKey:@"api_key"];
	[buffer setObject:version forKey:@"version"];
	[buffer setObject:[FCUUID uuidForDevice] forKey:@"deviceid"];
	NSLog(@"%@", buffer);
	printf("-------结束组装参数-------\n");
	return buffer;
}

@end
