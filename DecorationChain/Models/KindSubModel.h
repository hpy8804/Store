//
//  KindSubModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseObject.h"

@protocol KindSubProductModel <NSObject>
@end
@interface KindSubProductModel : BaseObject

@property (nonatomic, strong) NSString *id;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *name;

@end

@interface KindSubModel : BaseObject

@property (nonatomic, strong) NSArray <KindSubProductModel> *children;
@property (nonatomic, strong)  NSString *id;
@property (nonatomic, strong)  NSString *name;

@end
