//
//  OrderCreateModel.m
//  DecorationChain
//
//  Created by huangxinping on 4/8/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "OrderCreateModel.h"

@implementation OrderCreateContentModel

+ (JSONKeyMapper *)keyMapper {
	return [[JSONKeyMapper alloc] initWithDictionary:@{
	            @"description": @"self_description"
			}];
}

@end

@implementation OrderCreateModel

@end
