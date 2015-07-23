//
//  MyCollectionViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "MyCollectionViewModel.h"
#import "CollectionModel.h"
#import "NSDictionary+fill_deviceinfo.h"

@implementation MyCollectionViewModel

- (RACSignal *)collectionList:(NSString *)identifier page:(NSInteger)page {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/collection_list"
                parameters:[@{
                             @"account_id":identifier,
                             @"page":@(page) } fillDeviceInfo]]
             map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (NSArray *value) {
	    return [[[value rac_sequence] map: ^id (id value) {
	        return [[CollectionModel alloc] initWithDictionary:value error:nil];
		}] array];
	}];
}

- (RACSignal *)deleteCollection:(NSString *)identifier ids:(NSString *)ids {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/multi_delete_collection"
                parameters:[@{
                             @"account_id":identifier,
                             @"ids":ids } fillDeviceInfo]]
             map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return value;
	}];
}

@end
