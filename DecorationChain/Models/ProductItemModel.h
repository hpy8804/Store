/**
 *  <#filename#>
 *  ShareMerge
 *
 *  Created by huangxp on <#date#>.
 *
 *  产品项模型
 *
 *  Copyright (c) www.sharemerge.com All rights reserved.
 */

/** @file */    // Doxygen marker

#import "BaseObject.h"

@interface ProductItemModel : BaseObject

@property (nonatomic, strong) NSString <Optional> *createTime;
@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString <Optional> *images;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString<Optional> *price;
@property (nonatomic, strong) NSString *saleprice;
@property (nonatomic, strong) NSString <Optional> *weight;
@property (nonatomic, strong) NSString <Optional> *quantity;

@end
