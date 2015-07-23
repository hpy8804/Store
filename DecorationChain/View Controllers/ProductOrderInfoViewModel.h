//
//  ProductOrderInfoViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 4/8/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface ProductOrderInfoViewModel : BaseViewModel

/**
 *  获取支付宝信息
 *
 *  @param orderID 订单ID
 *
 *  @return 信号
 */
- (RACSignal *)alipayInfoWithOrderID:(NSString *)orderID;

@end
