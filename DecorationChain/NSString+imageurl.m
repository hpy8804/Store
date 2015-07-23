//
//  NSString+imageurl.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/18.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "NSString+imageurl.h"

@implementation NSString (imageurl)

- (NSString *)fullImageURL {
	return [NSString stringWithFormat:@"http://27.54.252.32/zjb/%@", self];
}

@end
