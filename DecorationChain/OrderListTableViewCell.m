//
//  OrderListTableViewCell.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/14.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "OrderListTableViewCell.h"

#import "NSString+imageurl.h"

#import <LASIImageView/LASIImageView.h>

@interface OrderListTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *serialTextField;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end

@implementation OrderListTableViewCell

- (void)awakeFromNib {
}

- (void)updateWithModel:(OrderListModel *)model {
	self.serialTextField.text = model.orderNumber;
	self.dateLabel.text = model.orderedOn;
	self.stateLabel.text = model.payStatusName;
	self.moneyLabel.text = [NSString stringWithFormat:@"￥%@", model.total ? model.total : @"0"];
	self.countLabel.text = model.items;
}

@end
