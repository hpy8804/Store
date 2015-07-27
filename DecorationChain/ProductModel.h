//
//  ProductModel.h
//  DecorationChain
//
//  Created by sven on 7/24/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface ProductModel : NSObject
@property (nonatomic, strong) NSString *proId;
@property (nonatomic, strong) NSString *en_name;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *cas;
@property (nonatomic, strong) NSString *formula;

@end
