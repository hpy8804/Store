//
//  MyOrderViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/21.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface MyOrderViewModel : BaseViewModel

/**
 *  获取订单列表
 *
 *  @param identifier  用户ID
 *  @param orderType   订单状态
 *  @param page        页码
 *
 *  @return 信号
 */
- (RACSignal *)orderListWithID:(NSString *)identifier orderType:(NSInteger)orderType page:(NSInteger)page;

/**
 *  获取订单详情
 *
 *  @param orderID 订单号
 *
 *  @return 信号
 */
- (RACSignal *)orderInfoWithOrderID:(NSString *)orderID;

/**
 *  确认收货
 *
 *  @param orderID 订单ID
 *
 *  @return 信号
 */
- (RACSignal *)orderConfirmFinishWithOrderID:(NSString *)orderID;

/**
 *  获取支付宝信息
 *
 *  @param orderID 订单ID
 *
 *  @return 信号
 */
- (RACSignal *)alipayInfoWithOrderID:(NSString *)orderID;

/**
 *  对订单进行评价
 *
 *  @param orderID      订单ID
 *  @param accountID    账号ID
 *  @param productID    产品ID
 *  @param commentClass 评价星级
 *  @param content      评价内容
 *
 *  @return 信号
 */
- (RACSignal *)orderScoreWithOrderID:(NSString *)orderID accountID:(NSString *)accountID productID:(NSString *)productID commentClass:(NSInteger)commentClass content:(NSString *)content;

@end
