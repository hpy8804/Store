//
//  MyCollectionViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface MyCollectionViewModel : BaseViewModel

/**
 *  获取我的收藏列表
 *
 *  @param identifier 用户ID
 *  @param page       页码
 *
 *  @return 信号
 */
- (RACSignal *)collectionList:(NSString *)identifier page:(NSInteger)page;

/**
 *  批量删除我的收藏
 *
 *  @param identifier 用户ID
 *  @param ids        收藏条目ID组
 *
 *  @return 信号
 */
- (RACSignal *)deleteCollection:(NSString *)identifier ids:(NSString *)ids;

@end
