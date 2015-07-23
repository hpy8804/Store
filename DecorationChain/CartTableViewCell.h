//
//  CartTableViewCell.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderModel.h"

@interface CartTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectedButton;

- (void)updateWithModel:(OrderModel *)model;

@end
