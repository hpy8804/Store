//
//  ProductInfoNumberTableViewCell.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductInfoModel.h"

@interface ProductInfoNumberTableViewCell : UITableViewCell
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

- (void)updateUIWithModel:(NSDictionary *)infoDic;

@end
