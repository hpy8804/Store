//
//  ProductInfoAttributeTableViewCell.m
//  DecorationChain
//
//  Created by huangxinping on 5/13/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "ProductInfoAttributeTableViewCell.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ProductInfoAttributeTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (nonatomic, assign) BOOL multiSelected;
@property (nonatomic, strong, readwrite) NSArray *set;
@property (nonatomic, weak) ProductInfoAttributeModel *model;
@end

@implementation ProductInfoAttributeTableViewCell

- (void)awakeFromNib {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

- (void)configWithModel:(ProductInfoAttributeModel *)model {
	self.model = model;
	self.nameLabel.text = model.attrName;
//	self.multiSelected = model.attrType.integerValue;
	self.multiSelected = NO;
	for (NSInteger i = 0; i < model.attrDetail.count; i++) {
		ProductInfoAttributeDetailModel *detail = model.attrDetail[i];
		UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
		[button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
		[button setTitle:detail.attrValue forState:UIControlStateNormal];
		[button setBackgroundImage:[UIImage imageNamed:@"ic_attr_common"] forState:UIControlStateNormal];
		[button setBackgroundImage:[UIImage imageNamed:@"ic_attr_check"] forState:UIControlStateSelected];
		button.titleLabel.font = [UIFont systemFontOfSize:15];
		button.frame = CGRectMake(75 + i * 63, 13, 55, 25);
		button.tag = 100 + i;
		[self addSubview:button];

		@weakify(self);
		[[[button rac_signalForControlEvents:UIControlEventTouchUpInside] takeUntil:self.rac_prepareForReuseSignal] subscribeNext: ^(id x) {
		    @strongify(self);
		    [self didTapAttributeButton:x];
		}];
	}
}

- (void)didTapAttributeButton:(UIButton *)button {
	button.selected = !button.selected;
	if (!self.multiSelected) {
		for (NSInteger i = 0; i < self.subviews.count; i++) {
			UIView *subView = self.subviews[i];
			if (subView.tag >= 100 && subView.tag != button.tag) {
				[(UIButton *)subView setSelected:NO];
			}
		}
	}
	NSMutableArray *tempArray = [NSMutableArray array];
	for (NSInteger i = 0; i < self.subviews.count; i++) {
		UIView *subView = self.subviews[i];
		if (subView.tag >= 100) {
			if ([(UIButton *)subView isSelected]) {
				ProductInfoAttributeDetailModel *detail = self.model.attrDetail[subView.tag - 100];
				[tempArray addObject:@{ @"attribute_id":self.model.attrId,
				                        @"detail_price":detail.attrPrice }];
			}
		}
	}
	self.set = tempArray;
}

@end
