//
//  ProductInfoViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface ProductInfoViewModel : BaseViewModel

/**
 *  通过产品ID获取产品详情
 *
 *  @param productID 产品ID
 *  @param identifier  用户ID（用于获取产品的收藏状态 - 可选）
 *
 *  @return 信号
 */
- (RACSignal *)productDetailWithID:(NSString *)identifier productID:(NSString *)productID;
/**
 *  添加产品到购物车
 *
 *  @param identifier 用户ID
 *  @param prodductID 产品ID
 *  @param quantity   数量
 *  @param attribute  属性数组
 *
 *  @return 信号
 */
- (RACSignal *)addProductToCartWithID:(NSString *)identifier productID:(NSString *)productID quantity:(NSInteger)quantity attribute:(NSArray *)attribute;

/**
 *  收藏产品
 *
 *  @param identifier 用户ID
 *  @param prodductID 产品ID
 *
 *  @return 信号
 */
- (RACSignal *)addCollectionProductWithID:(NSString *)identifier productID:(NSString *)productID;

/**
 *  删除收藏
 *
 *  @param identifier 用户ID
 *  @param prodductID 产品ID
 *
 *  @return 信号
 */
- (RACSignal *)deleteCollectionProductWithID:(NSString *)identifier productID:(NSString *)productID;

/**
 *  获取购物车数量
 *
 *  @param identifier 用户ID
 *
 *  @return 信号
 */
- (RACSignal *)cartDataNumberWithID:(NSString *)identifier;

@end
