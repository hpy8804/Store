//
//  KindGroupViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface KindGroupViewModel : BaseViewModel

/**
 *  获取列表数据
 *
 *  @param identifier 产品ID
 *  @param accountID  账户ID（未登录给0）
 *  @param page       页码
 *  @param saleSort   销量排序
 *  @param priceSmall 价格区间最小值
 *  @param priceBig   价格区间最大值
 *  @param createSort 创建时间
 *
 *  @return 信号
 */
- (RACSignal *)categoriesGroupWithId:(NSString *)identifier accountID:(NSString *)accountID page:(NSInteger)page saleSort:(NSString *)saleSort priceSmall:(NSString *)priceSmall priceBig:(NSString *)priceBig createSort:(NSString *)createSort;

@end
