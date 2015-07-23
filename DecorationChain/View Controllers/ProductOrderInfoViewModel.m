//
//  ProductOrderInfoViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 4/8/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "ProductOrderInfoViewModel.h"
#import "AlipayInfoModel.h"
#import "NSDictionary+fill_deviceinfo.h"

@implementation ProductOrderInfoViewModel

- (RACSignal *)alipayInfoWithOrderID:(NSString *)orderID {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/getpayinfo"
	            parameters  :[@{
	                              @"o_id":orderID
							  } fillDeviceInfo]] map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return value;
	}];
}

@end
