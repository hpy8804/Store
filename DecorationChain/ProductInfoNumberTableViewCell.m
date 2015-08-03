//
//  ProductInfoNumberTableViewCell.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ProductInfoNumberTableViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ProductInfoNumberTableViewCell ()

@end

@implementation ProductInfoNumberTableViewCell

- (void)awakeFromNib {
	@weakify(self);
	self.number = 0;

	[[self.reduceButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    self.number--;
	    self.number = self.number <= 0 ? 1 : self.number;
	    self.labelCount.text = [NSString stringWithFormat:@"%ld件", (long)self.number];
	}];
	[[self.increaseButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    self.number++;
	    self.number = self.number >= 99 ? 99 : self.number;
	    self.labelCount.text = [NSString stringWithFormat:@"%ld件", (long)self.number];
	}];
}

//@property (weak, nonatomic) IBOutlet UILabel *labelProductNO;
//@property (weak, nonatomic) IBOutlet UILabel *labelPurity;
//@property (weak, nonatomic) IBOutlet UILabel *labelOrigin;
//@property (weak, nonatomic) IBOutlet UILabel *labelInventory;
//@property (weak, nonatomic) IBOutlet UILabel *labelSpecifications;
//@property (weak, nonatomic) IBOutlet UILabel *labelPrice;
//@property (weak, nonatomic) IBOutlet UILabel *labelCount;
//@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
//@property (weak, nonatomic) IBOutlet UIButton *increaseButton;

- (void)updateUIWithModel:(NSDictionary *)infoDic
{
    self.labelProductNO.text = infoDic[@"good_number"];
    self.labelPurity.text = infoDic[@"pure"];
    self.labelOrigin.text = infoDic[@"pro_address"];
    self.labelInventory.text = infoDic[@"stock"];
    self.labelSpecifications.text = infoDic[@"norms"];
    self.labelPrice.text = [NSString stringWithFormat:@"¥%@", infoDic[@"good_price"]];
}

@end
