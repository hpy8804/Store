//
//  ProfileModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/11.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ProfileModel.h"

@implementation ProfileModel

- (instancetype)init {
	if ((self = [super init])) {
		self.wasLogin = NO;
	}
	return self;
}

- (void)readFromLocal {
	NSString *phone = [[NSUserDefaults standardUserDefaults] objectForKey:@"id"];
	NSString *password = [[NSUserDefaults standardUserDefaults] objectForKey:@"passwd"];
	if (phone && password) {
		[ProfileModel singleton].phone = phone;
		[ProfileModel singleton].password = password;
	}
}

@end
