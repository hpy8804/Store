//
//  ChangePasswordViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ChangePasswordViewModel.h"
#import "NSDictionary+fill_deviceinfo.h"

@implementation ChangePasswordViewModel

- (RACSignal *)updatePasswordWithPhone:(NSString *)phone oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword {
	return [[[self rac_GET:@"http://122.114.61.234/app/api/change_password"
	            parameters  :[@{
	                              @"username":phone,
	                              @"old_password":oldPassword,
	                              @"new_one":newPassword,
	                              @"new_two":newPassword
							  } fillDeviceInfo]] map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return value;
	}];
}

@end
