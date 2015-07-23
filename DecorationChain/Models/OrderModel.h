//
//  OrderModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseObject.h"

@interface OrderDetail : BaseObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *images;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString <Optional> *quantity;
@property (nonatomic, strong) NSString *saleprice;
@property (nonatomic, strong) NSString *weight;

@end

@interface OrderModel : BaseObject

@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) OrderDetail *detail;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString <Optional> *updateTime;

@end
