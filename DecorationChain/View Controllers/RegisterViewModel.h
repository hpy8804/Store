//
//  RegisterViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/11.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface RegisterViewModel : BaseViewModel

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
 *  注册
 *
 *  @param name     姓名
 *  @param email    邮箱
 *  @param phone    手机号
 *  @param password 密码
 *
 *  @return 信号
 */
- (RACSignal *)registerWithName:(NSString *)name email:(NSString *)email phone:(NSString *)phone password:(NSString *)password;


@end
