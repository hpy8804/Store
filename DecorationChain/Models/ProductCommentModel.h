//
//  ProductCommentModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseObject.h"

@interface ProductCommentModel : BaseObject

@property (nonatomic, strong) NSString *accountId;
@property (nonatomic, strong) NSString <Optional> *accountName;
@property (nonatomic, strong) NSString <Optional> *commentClass;
@property (nonatomic, strong) NSString <Optional> *content;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *ip;
@property (nonatomic, strong) NSString <Optional> *isGood;
@property (nonatomic, strong) NSString *isShow;
@property (nonatomic, strong) NSString *postTime;
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSString *score;

@end
