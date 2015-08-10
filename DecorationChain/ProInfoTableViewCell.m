//
//  ProInfoTableViewCell.m
//  DecorationChain
//
//  Created by sven on 8/10/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "ProInfoTableViewCell.h"

@implementation ProInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateCellWithInfo:(ProductInfoModelSV *)info
{
    self.labelhuohao.text = info.good_number;
    self.labelPure.text = info.pure;
    self.labelguige.text = info.norms;
    self.labelchandi.text = info.pro_address;
    self.labeljiage.text = [NSString stringWithFormat:@"¥%@", info.good_price];
    self.labelkucun.text = info.stock;
    self.labelshuliang.text = [NSString stringWithFormat:@"%@件", info.quantity];
}

@end
