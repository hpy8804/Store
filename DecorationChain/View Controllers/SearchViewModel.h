//
//  SearchViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/18.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"
#import "ProductItemModel.h"

@interface SearchViewModel : BaseViewModel

/**
 *  搜索
 *
 *  @param key 关键字
 *  @param page 页码
 *
 *  @return 信号
 */
- (RACSignal *)searchWithKey:(NSString *)key page:(NSInteger)page;

@end
