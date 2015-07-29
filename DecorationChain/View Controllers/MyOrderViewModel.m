//
//  MyOrderViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/21.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "MyOrderViewModel.h"
#import "OrderListModel.h"
#import "OrderInfoModel.h"
#import "NSDictionary+fill_deviceinfo.h"

@implementation MyOrderViewModel

- (RACSignal *)orderListWithID:(NSString *)identifier orderType:(NSInteger)orderType page:(NSInteger)page {
	return [[[self rac_GET:@"http://122.114.61.234/app/api/my_order"
	            parameters  :[@{
	                              @"account_id":identifier,
	                              @"order_type":@(orderType),
	                              @"page":@(page)
							  } fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (NSArray *value) {
	    return [[[value rac_sequence] map: ^id (id value) {
	        return [[OrderListModel alloc] initWithDictionary:value error:nil];
		}] array];
	}];
}

- (RACSignal *)orderInfoWithOrderID:(NSString *)orderID {
	return [[[self rac_GET:@"http://122.114.61.234/app/api/order_detail"
	            parameters  :[@{
	                              @"order_id":orderID
							  } fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return [[OrderInfoModel alloc] initWithDictionary:value error:nil];
	}];
}

- (RACSignal *)orderConfirmFinishWithOrderID:(NSString *)orderID {
	return [[[self rac_GET:@"http://122.114.61.234/app/api/confirm_goods"
	            parameters  :[@{
	                              @"order_id":orderID,
	                              @"status" : @"4"
							  } fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return value;
	}];
}

- (RACSignal *)alipayInfoWithOrderID:(NSString *)orderID {
	return [[[self rac_GET:@"http://122.114.61.234/app/api/getpayinfo"
	            parameters  :[@{
	                              @"o_id":orderID
							  } fillDeviceInfo]] map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return value;
	}];
}

- (RACSignal *)orderScoreWithOrderID:(NSString *)orderID accountID:(NSString *)accountID productID:(NSString *)productID commentClass:(NSInteger)commentClass content:(NSString *)content {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/product_comments"
	            parameters  :[@{
	                              @"order_id":orderID,
	                              @"account_id":accountID,
	                              @"product_id":productID,
	                              @"comment_class":@(commentClass),
	                              @"content":content
							  } fillDeviceInfo]] map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return value;
	}];
}

@end
