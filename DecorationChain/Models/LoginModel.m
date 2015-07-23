//
//  LoginModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "LoginModel.h"
#import <XPKit/NSObject+XPKit.h>
#import <XPKit/NSDictionary+XPKit.h>

@implementation LoginModel

- (id)copyWithZone:(NSZone *)zone {
	__block LoginModel *temp = [[[self class] allocWithZone:zone] init];
	NSDictionary *source = [self propertiesDictionary];
	[source each: ^(id key, id object) {
        if (object &&
            ![key isEqualToString:@"superclass"] &&
            ![key isEqualToString:@"hash"] &&
            ![key isEqualToString:@"debugDescription"]) {
            [temp setValue:object forKey:key];
        }
	}];
	return temp;
}

@end
