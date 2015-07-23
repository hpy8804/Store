//
//  KindGroupViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "KindGroupViewModel.h"
#import "KindGroupModel.h"
#import "NSDictionary+fill_deviceinfo.h"

@implementation KindGroupViewModel


- (RACSignal *)categoriesGroupWithId:(NSString *)identifier accountID:(NSString *)accountID page:(NSInteger)page saleSort:(NSString *)saleSort priceSmall:(NSString *)priceSmall priceBig:(NSString *)priceBig createSort:(NSString *)createSort {
	NSMutableDictionary *parameters = [@{ @"page":@(page) } mutableCopy];
	if (saleSort) {
		[parameters setObject:saleSort forKey:@"sale_num"];
	}
	if (createSort) {
		[parameters setObject:createSort forKey:@"create_time"];
	}
	if (priceSmall && priceBig) {
		[parameters setObject:priceSmall forKey:@"small"];
		[parameters setObject:priceBig forKey:@"big"];
	}

	[parameters setObject:identifier forKey:@"categories_id"];
	if (accountID) {
		[parameters setObject:accountID forKey:@"account_id"];
	}
	else {
		[parameters setObject:@"0" forKey:@"account_id"];
	}

	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/products"
	            parameters  :[parameters fillDeviceInfo]] map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (NSArray *value) {
	    return [[[value rac_sequence] map: ^id (id value) {
	        return [[KindGroupModel alloc] initWithDictionary:value error:nil];
		}] array];
	}];
}

@end
