//
//  ProductInfoModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ProductInfoModel.h"

#import <XPKit/NSObject+XPKit.h>

@implementation ProductInfoCommentModel

@end

@implementation ProductInfoPictureModel

@end

@implementation ProductInfoAttributeModel

@end

@implementation ProductInfoAttributeDetailModel

@end

@implementation ProductInfoModel

- (id)copyWithZone:(NSZone *)zone {
	__block ProductInfoModel *temp = [[[self class] allocWithZone:zone] init];
	NSDictionary *dictionary = [self propertiesDictionary];
	[dictionary enumerateKeysAndObjectsUsingBlock: ^(id key, id obj, BOOL *stop) {
	    if ([key isEqualToString:@"superclass"] || [key isEqualToString:@"hash"] || [key isEqualToString:@"debugDescription"]) {
		}
	    else {
	        [temp setValue:obj forKey:key];
		}
	}];
	return temp;
}

+ (JSONKeyMapper *)keyMapper {
	return [[JSONKeyMapper alloc] initWithDictionary:@{
	            @"description": @"self_description"
			}];
}

@end
