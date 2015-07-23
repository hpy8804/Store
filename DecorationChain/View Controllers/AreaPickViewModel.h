//
//  AreaPickViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 4/7/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface AreaPickViewModel : BaseViewModel

/**
 *  省份列表
 *
 *  @return 信号
 */
- (RACSignal *)provinces;

/**
 *  城市列表
 *
 *  @return 信号
 */
- (RACSignal *)citysWithProvinceID:(NSString *)provinceID;

/**
 *  区域列表
 *
 *  @return 信号
 */
- (RACSignal *)districtsWithCityID:(NSString *)cityID;

@end
