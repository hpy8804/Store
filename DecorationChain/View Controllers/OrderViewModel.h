//
//  OrderViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface OrderViewModel : BaseViewModel

/**
 *  获取会员折扣
 *
 *  @param identifier 用户ID
 *
 *  @return 信号
 */
- (RACSignal *)vipDiscountWithID:(NSString *)identifier;

/**
 *  获取购物车列表
 *
 *  @param identifier 用户ID
 *  @param page       页码
 *
 *  @return 信号
 */
- (RACSignal *)cartListWithID:(NSString *)identifier page:(NSInteger)page;

/**
 *  删除购物车列表
 *
 *  @param identifier 用户ID
 *  @param productID  购物车ID
 *
 *  @return 信号
 */
- (RACSignal *)deledateCartListWithID:(NSString *)identifier productID:(NSString *)productID;

@end
