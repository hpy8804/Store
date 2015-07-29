//
//  CollectionModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseObject.h"

@interface CollectionDetailModel : BaseObject

@property (nonatomic, strong) NSString *cas;
@property (nonatomic, strong) NSString *en_name;
@property (nonatomic, strong) NSString *formula;
@property (nonatomic, strong) NSString <Optional> *quantity;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *images;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *saleprice;
@property (nonatomic, strong) NSString *weight;

@end

@interface CollectionModel : BaseObject

@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString *collectionTime;
@property (nonatomic, strong) CollectionDetailModel *detail;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *productId;

@end
