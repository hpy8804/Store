//
//  ProductOrderViewController.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/21.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewController.h"
#import "ProductInfoModel.h"

@interface ProductOrderViewController : BaseViewController

/**
 *  标示订单来源（1-直接下单，2-从购物车下单）
 */
@property (nonatomic, assign) NSInteger orderStyle;
@property (strong, nonatomic) ProductInfoModel *infoModel;

/**
 *  设置订单数组
 *
 *  @param orders 订单数组（订单每个元素如下）
 *              //ProductInfoModel *infoModel = [self.infoModel copy];
 *              //infoModel.quantity = [NSString stringWithFormat:@"%ld", (long)cell.number];
 *
 */
- (void)updateUIWithOrders:(NSDictionary *)dicInfo;

@end
