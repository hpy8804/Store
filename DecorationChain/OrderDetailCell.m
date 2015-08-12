//
//  OrderDetailCell.m
//  DecorationChain
//
//  Created by sven on 8/12/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "OrderDetailCell.h"

@implementation OrderDetailModel


@end

@implementation OrderDetailCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateWithModel:(OrderDetailModel *)model
{
    self.mingcheng.text = model.mingcheng;
    self.labelhuohao.text = model.huohao;
    self.labelcundu.text = model.cundu;
    self.labelguige.text = model.guige;
    self.labelchandi.text = model.chandi;
    self.labeljiage.text = [NSString stringWithFormat:@"¥%@", model.jiage];
    self.labelshuliang.text = [NSString stringWithFormat:@"%@件", model.shuliang];
    self.labelkucun.text = model.kucun;
}

@end
