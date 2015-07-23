//
//  ProductOrderViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 4/7/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface ProductOrderViewModel : BaseViewModel

/**
 *  获取会员折扣
 *
 *  @param identifier 用户ID
 *
 *  @return 信号
 */
- (RACSignal *)vipDiscountWithID:(NSString *)identifier;

/**
 *  生成订单
 *
 *  @param identifier 用户ID
 *  @param addressID  地址ID
 *  @param products   产品组
 *  @param fpType     发票类型（如：纸质、电子）
 *  @param fpKind     发票种类（如：个人、公司）
 *  @param fpName     发票抬头
 *  @param payment    支付方式
 *  @param shipment   快递方式
 *  @param attribute  属性数组
 *  @param orderStyle 订单来源（1-直接下单，2-从购物车下单）
 *
 *  @return 信号
 */
- (RACSignal *)orderCreateWithID:(NSString *)identifier addressID:(NSString *)addressID products:(NSArray *)products fpType:(NSString *)fpType fpKind:(NSString *)fpKind fpName:(NSString *)fpName payment:(NSString *)payment shipment:(NSString *)shipment attribute:(NSArray *)attribute orderStyle:(NSInteger)orderStyle;

@end
