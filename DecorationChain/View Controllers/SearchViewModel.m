//
//  SearchViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/18.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "SearchViewModel.h"
#import "NSDictionary+fill_deviceinfo.h"

@implementation SearchViewModel

- (RACSignal *)searchWithKey:(NSString *)key page:(NSInteger)page {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/search_products"
	            parameters  :[@{
	                              @"name":key,
	                              @"page":@(page)
							  } fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (NSArray *data) {
	    return [[[data rac_sequence] map: ^id (id value) {
	        ProductItemModel *model = [[ProductItemModel alloc] initWithDictionary:value error:nil];
	        return model;
		}] array];
	}];
}

@end
