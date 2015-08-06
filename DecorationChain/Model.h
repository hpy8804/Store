//
//  Model.h
//  DecorationChain
//
//  Created by sven on 8/4/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

@end

@interface subCarList : NSObject
@property (nonatomic, strong) NSString *strId;
@property (nonatomic, strong) NSString *good_number;
@property (nonatomic, strong) NSString *pure;
@property (nonatomic, strong) NSString *norms;
@property (nonatomic, strong) NSString *pro_address;
@property (nonatomic, strong) NSString *good_price;
@property (nonatomic, strong) NSString *stock;
@property (nonatomic, strong) NSString *quantity;
@end

@interface CarlistCellModel : NSObject
@property (nonatomic, strong) NSString *account_id;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSArray *product_items;
@end
