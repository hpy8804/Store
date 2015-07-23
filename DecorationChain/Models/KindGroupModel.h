//
//  KindGroupModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseObject.h"

@interface KindGroupModel : BaseObject

@property (nonatomic, strong) NSString *brandId;
@property (nonatomic, strong) NSString <Optional> *createTime;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *price;
@property (nonatomic, strong) NSString *saleNum;
@property (nonatomic, strong) NSString *saleprice;
@property (nonatomic, strong) NSString <Optional> *vipprice;
@property (nonatomic, strong) NSString <Optional> *images;

@end
