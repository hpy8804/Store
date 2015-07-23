//
//  MainGroupViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/18.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

typedef NS_ENUM (NSUInteger, GroupType) {
	SPECIAL_GROUP, // 今日特价
	TUAN_GROUP, // 团购专区
	HOT_GROUP, // 热卖商品
	RECOMMEND_GROUP, // 精品推荐
	DAYDAYFREE_GROUP // 天天免单
};

@interface MainGroupViewModel : BaseViewModel

- (RACSignal *)fetchDataWithType:(GroupType)type page:(NSInteger)page saleSort:(NSString *)saleSort priceSmall:(NSString *)priceSmall priceBig:(NSString *)priceBig createSort:(NSString *)createSort;

@end
