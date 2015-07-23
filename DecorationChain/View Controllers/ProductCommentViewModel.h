//
//  ProductCommentViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface ProductCommentViewModel : BaseViewModel

/**
 *  获取评价列表
 *
 *  @param identifier 产品ID
 *  @param page       页码
 *
 *  @return 信号
 */
- (RACSignal *)productCommentListWithID:(NSString *)identifier page:(NSInteger)page;

@end
