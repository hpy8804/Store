//
//  RootViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/1/31.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface RootViewModel : BaseViewModel

@property (nonatomic, strong) RACSignal *logoImage;

/**
 *  获取广告列表
 *
 *  @return 信号
 */
- (RACSignal *)ads;

/**
 *  初始化
 *
 *  @return 信号
 */
- (RACSignal *)initialIndex;

@end
