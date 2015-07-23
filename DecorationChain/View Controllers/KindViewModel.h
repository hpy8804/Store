//
//  KindViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface KindViewModel : BaseViewModel

/**
 *  获取大分类
 *
 *  @return 信号
 */
- (RACSignal *)kinds;

/**
 *  获取二级分类
 *
 *  @param identifier 大分类ID
 *
 *  @return 信号
 */
- (RACSignal *)detailKindWithID:(NSString *)identifier;

/**
 *  广告
 *
 *  @return 信号
 */
- (RACSignal *)ads;

@end
