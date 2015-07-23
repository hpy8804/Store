//
//  SplashViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 4/7/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "SplashViewModel.h"

#import "NSDictionary+fill_deviceinfo.h"

@implementation SplashViewModel

- (RACSignal *)welcome {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/welcome"
	            parameters  :[@{
							  } fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (NSDictionary *data) {
	    return data[@"logo"];
	}];
}

@end
