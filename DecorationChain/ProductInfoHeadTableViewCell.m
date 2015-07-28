//
//  ProductInfoHeadTableViewCell.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ProductInfoHeadTableViewCell.h"

@implementation ProductInfoHeadTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

- (void)updateUIWithModel:(ProductInfoModel*)infoModel
{
    self.labelName.text = infoModel.name;
    self.labelCAS.text = infoModel.cas;
    self.labelName2.text = infoModel.name;
    self.labelEnName.text = infoModel.en_name;
    self.labelFormula.text = infoModel.formula;
    self.labelMolecular.text = infoModel.molecular;
    self.labelBoil.text = infoModel.boiling_point;
    self.labelFlash.text = infoModel.flash_point;
    self.labelPhysical.text = infoModel.matter;
}

@end
