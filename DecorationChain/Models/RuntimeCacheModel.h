//
//  RuntimeCacheModel.h
//  DecorationChain
//
//  Created by huangxinping on 4/7/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "BaseObject.h"

@interface RuntimeCacheModel : BaseObject

/**
 *  支付方式
 */
@property (nonatomic, strong) NSString *payment;

/**
 *  快递方式
 */
@property (nonatomic, strong) NSString *shipment;

/**
 *  发票抬头
 */
@property (nonatomic, strong) NSString *invoiceName;

/**
 *  订单号
 */
@property (strong, nonatomic) NSString *tradeNO;

/**
 *  支付
 */
@property (strong, nonatomic) NSString *payTimes;

@end
