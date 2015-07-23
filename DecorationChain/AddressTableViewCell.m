//
//  AddressTableViewCell.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "AddressTableViewCell.h"

@interface AddressTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation AddressTableViewCell

- (void)awakeFromNib {
}

- (void)updateWithModel:(AddressModel *)model {
	self.nameLabel.text = model.recipientsName;
	self.phoneLabel.text = model.telephone;
	if (model.province && model.city && model.district) {
		self.addressLabel.text = [NSString stringWithFormat:@"%@-%@-%@", model.province, model.city, model.district];
	}
	self.infoLabel.text = model.address;
}

@end
