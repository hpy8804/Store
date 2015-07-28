//
//  ProductInfoViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ProductInfoViewModel.h"
#import "ProductInfoModel.h"
#import "NSDictionary+fill_deviceinfo.h"

@implementation ProductInfoViewModel


- (RACSignal *)productDetailWithID:(NSString *)identifier productID:(NSString *)productID {
	NSMutableDictionary *parameters = [@{ @"id":productID } mutableCopy];
	if (identifier) {
		[parameters setObject:identifier forKey:@"account_id"];
	}
	return [[[self rac_GET:@"http://122.114.61.234/app/api/pro_detail"
	            parameters  :[parameters fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    ProductInfoModel *model = [[ProductInfoModel alloc] initWithDictionary:value error:nil];
	    return model;
	}];
}

- (RACSignal *)addProductToCartWithID:(NSString *)identifier productID:(NSString *)productID quantity:(NSInteger)quantity attribute:(NSArray *)attribute {
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
	__block NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:identifier forKey:@"account_id"];
	[parameters setObject:productID forKey:@"product_id"];
	[parameters setObject:@(quantity) forKey:@"quantity"];

	for (NSInteger i = 0; i < attribute.count; i++) {
		NSArray *itemAttribute = attribute[i]; // 每一行
		[itemAttribute each: ^(NSDictionary *item) { // 每一列
		    NSString *key1 = [NSString stringWithFormat:@"attr[%ld][key]", (long)i+1];
		    [parameters setObject:item[@"attribute_id"] forKey:key1];
		    NSString *key2 = [NSString stringWithFormat:@"attr[%ld][val]", (long)i+1];
		    [parameters setObject:item[@"detail_price"] forKey:key2];
		}];
	}

	return [[[self rac_POST:@"http://27.54.252.32/zjb/api/add_to_cart"
	             parameters :[parameters fillDeviceInfo]] map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return value;
	}];
}

- (RACSignal *)addCollectionProductWithID:(NSString *)identifier productID:(NSString *)productID {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/collect_product_get"
	            parameters  :[@{
	                              @"account_id":identifier,
	                              @"product_id":productID
							  } fillDeviceInfo]] map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return value;
	}];
}

- (RACSignal *)deleteCollectionProductWithID:(NSString *)identifier productID:(NSString *)productID {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/delete_collect"
	            parameters  :[@{
	                              @"account_id":identifier,
	                              @"product_id":productID
							  } fillDeviceInfo]] map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return value;
	}];
}

- (RACSignal *)cartDataNumberWithID:(NSString *)identifier {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/cart_products_nums"
	            parameters  :[@{
	                              @"account_id":identifier
							  } fillDeviceInfo]] map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    if ([value isKindOfClass:[NSArray class]]) {
	        return @(0);
		}
	    return value;
	}];
}

@end
