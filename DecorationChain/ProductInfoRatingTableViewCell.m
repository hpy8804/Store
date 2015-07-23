//
//  ProductInfoRatingTableViewCell.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ProductInfoRatingTableViewCell.h"

@implementation ProductInfoRatingTableViewCell

- (void)awakeFromNib {
}

- (void)updateWithModel:(ProductInfoCommentModel *)model {
	[self.ratingBar setStarNumber:model.score.integerValue];
	self.ratingBar.enable = NO;
	self.nickLabel.text = model.accountName;
	XPDateInformation di = [[NSDate dateWithTimeIntervalSince1970:model.postTime.integerValue] dateInformation];
	self.dateLabel.text = [NSString stringWithFormat:@"%.2ld-%.2ld %.2ld:%.2ld", di.month, di.day, di.hour, di.minute];
	self.contentLabel.text = model.content;
}

@end
