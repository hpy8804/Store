//
//  ProfileModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/11.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseObject.h"
#import "LoginModel.h"

@interface ProfileModel : BaseObject

/**
 *  是否已经登陆
 */
@property (nonatomic, assign) BOOL wasLogin;

/**
 *  登陆后的信息模型
 */
@property (nonatomic, strong) LoginModel *model;

/**
 *  手机号
 */
@property (nonatomic, strong) NSString *phone;

/**
 *  密码
 */
@property (nonatomic, strong) NSString *password;

/**
 *  读取本地信息
 */
- (void)readFromLocal;

@end
