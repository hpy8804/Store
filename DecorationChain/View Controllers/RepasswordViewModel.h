//
//  RepasswordViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/7/22.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface RepasswordViewModel : BaseViewModel

/**
 *  手机号信号
 */
@property (nonatomic, strong) RACSignal *mobileSignal;

/**
 *  获取验证码按钮启用信号
 */
@property (nonatomic, strong) RACSignal *validCodeButtonSignal;

/**
 *  验证码信号
 */
@property (nonatomic, strong) RACSignal *codeSignal;

/**
 *  提交验证码启用信号
 */
@property (nonatomic, strong) RACSignal *validSubmitCodeButtonSignal;

/**
 *  发送验证码
 *
 *  @param phone 手机号
 *
 *  @return 信号
 */
- (RACSignal *)sendCodeWithPhone:(NSString *)phone;

/**
 *  验证验证码
 *
 *  @param phone 手机号
 *  @param code  验证码
 *
 *  @return 信号
 */
- (RACSignal *)validateCodeWithPhone:(NSString *)phone code:(NSString *)code;

/**
 *  重置密码
 *
 *  @param name     用户名
 *  @param password 新密码
 *
 *  @return 信号
 */
- (RACSignal *)repasswordWithName:(NSString *)name password:(NSString *)password;

@end
