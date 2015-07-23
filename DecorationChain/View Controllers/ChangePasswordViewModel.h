//
//  ChangePasswordViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface ChangePasswordViewModel : BaseViewModel

/**
 *  修改密码
 *
 *  @param phone       手机号
 *  @param oldPassword 旧密码
 *  @param newPassword 新密码
 *
 *  @return 信号
 */
- (RACSignal *)updatePasswordWithPhone:(NSString *)phone oldPassword:(NSString *)oldPassword newPassword:(NSString *)newPassword;

@end
