//
//  OrderInfoModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/21.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "OrderInfoModel.h"

@implementation OrderInfoContentModel

+ (JSONKeyMapper *)keyMapper {
	return [[JSONKeyMapper alloc] initWithDictionary:@{
	            @"description": @"self_description"
			}];
}

@end

@implementation OrderInfoModel

@end
