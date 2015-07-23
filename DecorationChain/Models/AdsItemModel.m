//
//  AdsItemModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/18.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "AdsItemModel.h"

@implementation AdsItemModel

+ (JSONKeyMapper *)keyMapper {
	return [[JSONKeyMapper alloc] initWithDictionary:@{
	            @"description": @"self_description"
			}];
}

@end
