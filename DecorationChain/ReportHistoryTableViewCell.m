//
//  ReportHistoryTableViewCell.m
//  DecorationChain
//
//  Created by huangxinping on 15/5/29.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ReportHistoryTableViewCell.h"
#import "ReportHistoryModel.h"

#import <XPKit/XPKit.h>

@interface ReportHistoryTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *stateLabel;

@end

@implementation ReportHistoryTableViewCell

- (void)awakeFromNib {
}

- (void)updateWithModel:(ReportHistoryModel *)model {
	self.numberLabel.text = model.number;
	XPDateInformation di = [[NSDate dateWithTimeIntervalSince1970:model.postTime.integerValue] dateInformation];
	self.timeLabel.text = [NSString stringWithFormat:@"%ld-%.2ld-%.2ld %.2ld:%.2ld", di.year, di.month, di.day, di.hour, di.minute];
	self.stateLabel.text = [model.enable boolValue] ? @"已确认" : @"未确认";
}

@end
