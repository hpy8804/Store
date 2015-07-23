//
//  LoginViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/1/28.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "LoginViewModel.h"
#import "LoginModel.h"
#import "NSDictionary+fill_deviceinfo.h"

@implementation LoginViewModel

- (instancetype)init {
	self = [super init];
	if (self) {
		@weakify(self);
		[self.didBecomeActiveSignal
		 subscribeNext: ^(id x) {
		    @strongify(self);
		}];
	}
	return self;
}

- (RACSignal *)signInButtonEnableSignal {
	if (!self.validUserSignal || !self.validPasswordSignal) {
		return [RACSignal return :@(0)];
	}
	return [RACSignal combineLatest:@[self.validUserSignal, self.validPasswordSignal] reduce: ^id (NSNumber *userValid, NSNumber *passowordValid) {
	    return @(userValid.boolValue && passowordValid.boolValue);
	}];
}

- (RACSignal *)usernameBackgroundColorSignal {
	return [self.validUserSignal map: ^id (NSNumber *isValid) {
	    return isValid.boolValue ? [UIColor clearColor] : [UIColor yellowColor];
	}];
}

- (RACSignal *)passwordBackgroundColorSignal {
	return [self.validPasswordSignal map: ^id (NSNumber *isValid) {
	    return isValid.boolValue ? [UIColor clearColor] : [UIColor yellowColor];
	}];
}

- (BOOL)isValidUsername:(NSString *)username {
	return username.length > 3;
}

- (BOOL)isValidPassword:(NSString *)password {
	return password.length > 3;
}

- (void)setValidUserSignal:(RACSignal *)validUserSignal {
	validUserSignal =  [validUserSignal map: ^id (NSString *value) {
	    return @([self isValidUsername:value]);
	}];
}

- (void)setValidPasswordSignal:(RACSignal *)validPasswordSignal {
	validPasswordSignal =  [validPasswordSignal map: ^id (NSString *value) {
	    return @([self isValidPassword:value]);
	}];
}

- (RACSignal *)signInSignal:(NSString *)userName password:(NSString *)password {
	return [[[[self rac_GET:@"http://27.54.252.32/zjb/api/login"
	             parameters  :[@{
	                               @"username":userName,
	                               @"password":password
							   } fillDeviceInfo]]
	          map: ^id (id value) {
	    return [self analysisRequest:value];
	}] filter: ^BOOL (id value) {
	    return YES;
	}] map: ^id (id value) {
	    if ([value isKindOfClass:[NSArray class]] && ![(NSArray *)value count]) {
	        return nil;
		}
	    return [[LoginModel alloc] initWithDictionary:value error:nil];
	}];
}

@end
