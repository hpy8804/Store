//
//  ProductOrderAddressView.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/24.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ProductOrderAddressView.h"

@interface ProductOrderAddressView ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *phoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *infoLabel;

@end

@implementation ProductOrderAddressView

- (void)updateWithModel:(AddressModel *)model {
	self.nameLabel.text = model.recipientsName;
	self.phoneLabel.text = model.telephone;
	if (model.province && model.city && model.district) {
		self.locationLabel.text = [NSString stringWithFormat:@"%@-%@-%@", model.province, model.city, model.district];
	}
	self.infoLabel.text = model.address;
	[self.infoLabel sizeToFit];
}

@end
