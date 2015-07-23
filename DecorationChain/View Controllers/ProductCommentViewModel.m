//
//  ProductCommentViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ProductCommentViewModel.h"
#import "ProductCommentModel.h"
#import "NSDictionary+fill_deviceinfo.h"

@implementation ProductCommentViewModel

- (RACSignal *)productCommentListWithID:(NSString *)identifier page:(NSInteger)page {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/product_comments_list"
	            parameters  :[@{
	                              @"id":identifier,
	                              @"page":@(page)
							  } fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (NSArray *value) {
	    return [[[value rac_sequence] map: ^id (id value) {
	        ProductCommentModel *model = [[ProductCommentModel alloc] initWithDictionary:value error:nil];
	        return model;
		}] array];
	}];
}

@end
