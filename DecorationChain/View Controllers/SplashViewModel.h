//
//  SplashViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 4/7/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface SplashViewModel : BaseViewModel

/**
 *  获取启动展示图
 *
 *  @return 信号
 */
- (RACSignal *)welcome;

@end
