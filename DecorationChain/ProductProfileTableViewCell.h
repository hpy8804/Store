//
//  ProductProfileTableViewCell.h
//  DecorationChain
//
//  Created by sven on 7/24/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductModel.h"

@interface ProductProfileTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *en_name;
@property (weak, nonatomic) IBOutlet UILabel *cas;
@property (weak, nonatomic) IBOutlet UILabel *formula;

@property (strong, nonatomic) ProductModel *productModel;

@end
