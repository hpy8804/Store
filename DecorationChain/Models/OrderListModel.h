//
//  OrderListModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/21.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseObject.h"

@interface OrderListProductModel : BaseObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *images;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *saleprice;

@end

@interface OrderListModel : BaseObject

@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString <Optional> *items;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString <Optional> *orderStatus;
@property (nonatomic, strong) NSString *orderStatusName;
@property (nonatomic, strong) NSString *orderedOn;
@property (nonatomic, strong) NSString *payStatus;
@property (nonatomic, strong) NSString *payStatusName;
@property (nonatomic, strong) OrderListProductModel <Optional> *products;
@property (nonatomic, strong) NSString *status;
@property (nonatomic, strong) NSString *order_type;
@property (nonatomic, strong) NSString <Optional> *subtotal;
@property (nonatomic, strong) NSString *total;

@end
