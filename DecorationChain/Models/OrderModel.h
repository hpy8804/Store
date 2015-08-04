//
//  OrderModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseObject.h"

@interface OrderDetail : BaseObject

@property (nonatomic, strong) NSString *boiling_point;
@property (nonatomic, strong) NSString *brandcate_id;
@property (nonatomic, strong) NSString *cas;
@property (nonatomic, strong) NSString *categories_id;
@property (nonatomic, strong) NSString *description;
@property (nonatomic, strong) NSString *en_name;
@property (nonatomic, strong) NSString *excerpt;
@property (nonatomic, strong) NSString *flash_point;
@property (nonatomic, strong) NSString *formula;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *matter;
@property (nonatomic, strong) NSString *multing_point;
@property (nonatomic, strong) NSString *molecular;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *number;
@property (nonatomic, strong) NSString *options;
@property (nonatomic, strong) NSString *post_options;
@property (nonatomic, strong) NSString *route_id;
@property (nonatomic, strong) NSString *saleprice;
@property (nonatomic, strong) NSString *sku;
@property (nonatomic, strong) NSString *slug;
@property (nonatomic, strong) NSString *thickness;

@end

@interface OrderModel : BaseObject

@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) OrderDetail *detail;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *quantity;
@property (nonatomic, strong) NSString <Optional> *updateTime;

@end
