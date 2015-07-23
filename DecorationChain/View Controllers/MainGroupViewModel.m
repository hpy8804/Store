//
//  MainGroupViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/18.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "MainGroupViewModel.h"
#import "ProductItemModel.h"
#import "NSDictionary+fill_deviceinfo.h"

@implementation MainGroupViewModel

- (RACSignal *)fetchDataWithType:(GroupType)type page:(NSInteger)page saleSort:(NSString *)saleSort priceSmall:(NSString *)priceSmall priceBig:(NSString *)priceBig createSort:(NSString *)createSort {
	NSString *url = nil;
	switch (type) {
		case SPECIAL_GROUP:
			url = @"http://27.54.252.32/zjb/api/special_products";
			break;

		case TUAN_GROUP:
			url = @"http://27.54.252.32/zjb/api/tuan_products";
			break;

		case HOT_GROUP:
			url = @"http://27.54.252.32/zjb/api/hot_products";
			break;

		case RECOMMEND_GROUP:
			url = @"http://27.54.252.32/zjb/api/recommend_products";
			break;

		case DAYDAYFREE_GROUP:
			url = @"http://27.54.252.32/zjb/api/free_products";
			break;

		default:
			break;
	}
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
	return [[[self rac_GET:url parameters:[parameters fillDeviceInfo]] map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return [[[value rac_sequence] map: ^id (id value) {
	        return [[ProductItemModel alloc] initWithDictionary:value error:nil];
		}] array];
	}];
}

@end
