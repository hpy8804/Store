//
//  RootViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/1/31.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "RootViewModel.h"
#import "AdsItemModel.h"
#import "ProductItemModel.h"
#import "NSDictionary+fill_deviceinfo.h"

@implementation RootViewModel

- (instancetype)init {
	if ((self = [super init])) {
		@weakify(self);
		[self.didBecomeActiveSignal subscribeNext: ^(id x) {
		    @strongify(self);
		    self.logoImage = [self rac_remoteImage:@"https://coding.net/static/project_icon/scenery-17.png"];
		}];
		[self.didBecomeInactiveSignal subscribeNext: ^(id x) {
		}];
	}
	return self;
}

- (RACSignal *)ads {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/ads"
	            parameters  :[@{} fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (NSArray *data) {
	    return [[[data rac_sequence] map: ^id (id value) {
	        AdsItemModel *model = [[AdsItemModel alloc] initWithDictionary:value error:nil];
	        return model;
		}] array];
	}];
}

- (RACSignal *)initialIndex {
	return [[[[self rac_GET:@"http://27.54.252.32/zjb/api/initail_index"
	             parameters  :[@{} fillDeviceInfo]]
	          map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (NSDictionary *value) {
	    return @[value[@"specials"], value[@"tuans"], value[@"hots"], value[@"recommends"]];
	}] map: ^id (NSArray *value) {
	    NSArray *speciasl = value[0];
	    speciasl = [[[speciasl rac_sequence] map: ^id (id value) {
	        return [[ProductItemModel alloc] initWithDictionary:value error:nil];
		}] array];

	    NSArray *tuans = value[1];
	    tuans = [[[tuans rac_sequence] map: ^id (id value) {
	        return [[ProductItemModel alloc] initWithDictionary:value error:nil];
		}] array];

	    NSArray *hots = value[2];
	    hots = [[[hots rac_sequence] map: ^id (id value) {
	        return [[ProductItemModel alloc] initWithDictionary:value error:nil];
		}] array];

	    NSArray *recommends = value[3];
	    recommends = [[[recommends rac_sequence] map: ^id (id value) {
	        return [[ProductItemModel alloc] initWithDictionary:value error:nil];
		}] array];
	    return @[speciasl, tuans, hots, recommends];
	}];
}

@end
