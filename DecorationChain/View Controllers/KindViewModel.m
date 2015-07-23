//
//  KindViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "KindViewModel.h"

#import "kindModel.h"
#import "KindSubModel.h"
#import "AdsItemModel.h"
#import "NSDictionary+fill_deviceinfo.h"

@implementation KindViewModel

- (RACSignal *)kinds {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/left_menu"
	            parameters  :[@{
							  } fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (NSArray *value) {
	    return [[[value rac_sequence] map: ^id (id value) {
	        return [[kindModel alloc] initWithDictionary:value error:nil];
		}] array];
	}];
}

- (RACSignal *)detailKindWithID:(NSString *)identifier {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/detail_cates"
	            parameters  :[@{
	                              @"parent_id":identifier
							  } fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (NSArray *value) {
	    return [[[value rac_sequence] map: ^id (id value) {
	        return [[KindSubModel alloc] initWithDictionary:value error:nil];
		}] array];
	}];
}

- (RACSignal *)ads {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/ads"
	            parameters  :[@{
							  } fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (NSArray *data) {
	    return [[[data rac_sequence] map: ^id (id value) {
	        AdsItemModel *model = [[AdsItemModel alloc] initWithDictionary:value error:nil];
	        return model;
		}] array];
	}];
}

@end
