//
//  OrderViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "OrderViewModel.h"

#import "OrderModel.h"
#import "NSDictionary+fill_deviceinfo.h"

@implementation OrderViewModel

- (RACSignal *)cartListWithID:(NSString *)identifier page:(NSInteger)page {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/cart_lists"
	            parameters  :[@{
	                              @"account_id":identifier,
	                              @"page":@(page)
							  } fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (NSArray *value) {
	    return [[[value rac_sequence] map: ^id (id value) {
	        return [[OrderModel alloc] initWithDictionary:value error:nil];
		}] array];
	}];
}

- (RACSignal *)deledateCartListWithID:(NSString *)identifier productID:(NSString *)productID {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/cart_product_delete"
	            parameters  :[@{
	                              @"account_id":identifier,
	                              @"id":productID
							  } fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return value;
	}];
}

- (RACSignal *)vipDiscountWithID:(NSString *)identifier {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/vip_percent" parameters:[@{ @"account_id":identifier } fillDeviceInfo]] map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (NSDictionary *value) {
	    if ([value[@"is_vip"] isKindOfClass:[NSNumber class]] && [value[@"is_vip"] boolValue]) {
	        return @([value[@"vip_percent"] floatValue]);
		}
	    return @(1);
	}];
}

@end
