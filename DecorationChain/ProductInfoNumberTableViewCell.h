//
//  ProductInfoNumberTableViewCell.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductInfoNumberTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UIButton *increaseButton;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (nonatomic, assign) NSInteger number;

@end
