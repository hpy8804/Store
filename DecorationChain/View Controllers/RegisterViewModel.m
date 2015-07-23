//
//  RegisterViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/11.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "RegisterViewModel.h"
#import "RegisterModel.h"

#import "NSDictionary+fill_deviceinfo.h"

@interface NSString (ex)

- (BOOL)isPhone;

- (BOOL)isCode;

@end

@implementation NSString (ex)

- (BOOL)isPhone {
	return (self.length > 0 &&
	        self.length == 11 &&
	        [[self substringToIndex:1] isEqualToString:@"1"]);
}

- (BOOL)isCode {
	return (self.length == 4);
}

@end

@implementation RegisterViewModel

- (instancetype)init {
	if ((self = [super init])) {
	}
	return self;
}

- (void)setMobileSignal:(RACSignal *)mobileSignal {
	_mobileSignal = [mobileSignal map: ^id (id value) {
	    return value;
	}];
	self.validCodeButtonSignal  = [RACSignal combineLatest:@[_mobileSignal]
	                                                reduce: ^(NSString *mobile) {
	    return @([mobile isPhone]);
	}];
}

- (void)setCodeSignal:(RACSignal *)codeSignal {
	_codeSignal = [codeSignal map: ^id (id value) {
	    return value;
	}];
	self.validSubmitCodeButtonSignal  = [RACSignal combineLatest:@[_codeSignal]
	                                                      reduce: ^(NSString *mobile) {
	    return @([mobile isCode]);
	}];
}

- (RACSignal *)sendCodeWithPhone:(NSString *)phone {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/account_send"
                parameters:[@{
                             @"telephone":phone } fillDeviceInfo]]
             map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return [[RegisterAndSendModel alloc] initWithDictionary:value error:nil];
	}];
}

- (RACSignal *)validateCodeWithPhone:(NSString *)phone code:(NSString *)code {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/account_msg_validate"
                parameters:[@{
                             @"telephone":phone,
                             @"code":code } fillDeviceInfo]] map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return [[RegisterAndValidateModel alloc] initWithDictionary:value error:nil];
	}];
}

- (RACSignal *)registerWithName:(NSString *)name email:(NSString *)email phone:(NSString *)phone password:(NSString *)password {
	NSMutableDictionary *parameters = [@{ @"name":name, @"telephone":phone, @"password":password, @"password1":password } mutableCopy];
	if (email) {
		[parameters setObject:email forKey:@"email"];
	}
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/account_register"
                parameters:[parameters fillDeviceInfo]]
             map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
        RegisterModel *model = [[RegisterModel alloc] initWithDictionary:value error:nil];
	    return model;
	}];
}

@end
