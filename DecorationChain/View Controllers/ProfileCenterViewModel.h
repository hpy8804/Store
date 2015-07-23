//
//  ProfileCenterViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface ProfileCenterViewModel : BaseViewModel

/**
 *  修改个人资料
 *
 *  @param identifier 用户ID
 *  @param name       姓名
 *  @param email      邮箱
 *  @param telephone  手机号
 *  @param avatarURL  头像地址
 *
 *  @return 信号
 */
- (RACSignal *)updateProfileWithID:(NSString *)identifier name:(NSString *)name email:(NSString *)email telephone:(NSString *)telephone avatarURL:(NSString *)avatarURL;

/**
 *  更新头像
 *
 *  @param identifier 用户ID
 *  @param image      图片数据
 *
 *  @return 信号
 */
- (RACSignal *)updateAvatarWithID:(NSString *)identifier image:(UIImage *)image;

@end
