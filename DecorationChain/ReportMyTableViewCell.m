//
//  ReportMyTableViewCell.m
//  DecorationChain
//
//  Created by huangxinping on 15/5/29.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ReportMyTableViewCell.h"
#import "ReportStoreModel.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ReportMyTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *brandLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UILabel *kindLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *skuLabel;
@property (weak, nonatomic) IBOutlet UILabel *normsLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIButton *reduceButton;
@property (weak, nonatomic) IBOutlet UIButton *increaseButton;
@property (nonatomic, weak) ReportStoreModel *model;
@end

@implementation ReportMyTableViewCell

- (void)awakeFromNib {
	@weakify(self);
	[[self.reduceButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    NSInteger buffer = self.number;
	    buffer--;
	    buffer = buffer <= 0 ? 1 : buffer;
	    self.number = buffer;
	    self.model.nums = [NSString stringWithFormat:@"%ld", (long)self.number];
	    self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.number];
	}];
	[[self.increaseButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    NSInteger buffer = self.number;
	    buffer++;
	    buffer = buffer >= 99 ? 99 : buffer;
	    self.number = buffer;
	    self.model.nums = [NSString stringWithFormat:@"%ld", (long)self.number];
	    self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.number];
	}];

	[[self.selectButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    self.selectButton.selected = !self.selectButton.selected;
	}];
}

- (BOOL)selectedReport {
	return self.selectButton.selected;
}

- (void)updateWithModel:(ReportStoreModel *)model {
	self.model = model;
	self.nameLabel.text = model.name;
	self.brandLabel.text = model.brandName;
	self.unitLabel.text = model.unit;
	self.kindLabel.text = model.categoryName;
	self.skuLabel.text = model.sku;
	self.normsLabel.text = model.norms;
	self.number = model.nums.integerValue;
	self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)self.number];
}

@end
