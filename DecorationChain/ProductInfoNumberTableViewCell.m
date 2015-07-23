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
	self.number = 1;

	[[self.reduceButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    self.number--;
	    self.number = self.number <= 0 ? 1 : self.number;
	    self.numberLabel.text = [NSString stringWithFormat:@"%ld件", (long)self.number];
	}];
	[[self.increaseButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    self.number++;
	    self.number = self.number >= 99 ? 99 : self.number;
	    self.numberLabel.text = [NSString stringWithFormat:@"%ld件", (long)self.number];
	}];
}

@end
