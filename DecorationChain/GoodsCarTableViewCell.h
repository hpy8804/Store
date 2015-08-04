//
//  GoodsCarTableViewCell.h
//  DecorationChain
//
//  Created by sven on 8/4/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Model.h"

@interface GoodsCarTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelProductNO;
@property (weak, nonatomic) IBOutlet UILabel *labelPurity;
@property (weak, nonatomic) IBOutlet UILabel *labelOrigin;
@property (weak, nonatomic) IBOutlet UILabel *labelInventory;
@property (weak, nonatomic) IBOutlet UILabel *labelSpecifications;
@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
@property (weak, nonatomic) IBOutlet UILabel *labelCount;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UIButton *increaseButton;

@property (nonatomic, assign) NSInteger number;

- (void)updateUIWithModel:(subCarList *)carlist;
@end
