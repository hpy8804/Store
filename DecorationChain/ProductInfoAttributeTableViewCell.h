//
//  ProductInfoAttributeTableViewCell.h
//  DecorationChain
//
//  Created by huangxinping on 5/13/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductInfoModel.h"

@interface ProductInfoAttributeTableViewCell : UITableViewCell

@property (nonatomic, strong, readonly) NSArray *set;

- (void)configWithModel:(ProductInfoAttributeModel *)model;

@end
