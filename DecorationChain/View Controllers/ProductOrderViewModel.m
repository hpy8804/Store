//
//  ProductOrderViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 4/7/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "ProductOrderViewModel.h"

#include "NSDictionary+fill_deviceinfo.h"

#import "OrderCreateModel.h"

#import <ASIHTTPRequest/ASIFormDataRequest.h>
#import "ProductInfoModelSV.h"

@implementation ProductOrderViewModel

- (RACSignal *)orderCreateWithID:(NSString *)identifier addressID:(NSString *)addressID products:(NSArray *)products fpType:(NSString *)fpType fpKind:(NSString *)fpKind fpName:(NSString *)fpName payment:(NSString *)payment shipment:(NSString *)shipment attribute:(NSArray *)attribute orderStyle:(NSInteger)orderStyle {
	__block NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:identifier forKey:@"account_id"];
	[parameters setObject:addressID forKey:@"address_id"];
	for (NSInteger i = 0; i < products.count; i++) {
        NSDictionary *subDic = products[i];
        NSArray *subArr = [subDic allValues][0];
        for (int j = 0; j < subArr.count; j++) {
            ProductInfoModelSV *model = (ProductInfoModelSV *)subArr[i];
            //		NSArray *itemProduct = products[i];
            NSString *productID = model.strID;
            NSString *number = model.quantity;
            [parameters setObject:productID forKey:[NSString stringWithFormat:@"product[%ld][id]", (long)i]];
            [parameters setObject:number forKey:[NSString stringWithFormat:@"product[%ld][quantity]", (long)i]];
        }
        
	}

//    attribute -- 属性数组，多行、多列
//    如：[
//      {
//          attribute_id:111,
//          detail_price:25.6
//      },
//      {
//          attribute_id:222,
//          detail_price:15.6
//      }
//    ],
//        [
//      {
//          attribute_id:333,
//          detail_price:5.6
//      }
//    ]
	for (NSInteger i = 0; i < attribute.count; i++) {
		NSArray *itemAttribute = attribute[i]; // 每一行
		[itemAttribute each: ^(NSDictionary *item) { // 每一列
		    NSString *key1 = [NSString stringWithFormat:@"attr[%ld][key]", (long)i + 1];
		    [parameters setObject:item[@"attribute_id"] forKey:key1];
		    NSString *key2 = [NSString stringWithFormat:@"attr[%ld][val]", (long)i + 1];
		    [parameters setObject:item[@"detail_price"] forKey:key2];
		}];
	}


	if (fpName && ![fpName isEqualToString:@""]) {
		[parameters setObject:fpName forKey:@"fp_name"];
	}
	[parameters setObject:fpKind forKey:@"per_type"];
	[parameters setObject:fpType forKey:@"fp_cate_id"];
	[parameters setObject:payment forKey:@"payment"];
	[parameters setObject:shipment forKey:@"shipment"];
	[parameters setObject:@"1" forKey:@"bill_type"];
	[parameters setObject:@"" forKey:@"more"];
	[parameters setObject:@(orderStyle) forKey:@"order_style"];
	return [[[self rac_POST:@"http://122.114.61.234/app/api/place_order"
	             parameters :[parameters fillDeviceInfo]] map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return [[OrderCreateModel alloc] initWithDictionary:value error:nil];
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
