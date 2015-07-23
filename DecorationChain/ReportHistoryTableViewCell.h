//
//  ReportHistoryTableViewCell.h
//  DecorationChain
//
//  Created by huangxinping on 15/5/29.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReportHistoryModel;
@interface ReportHistoryTableViewCell : UITableViewCell

- (void)updateWithModel:(ReportHistoryModel *)model;

@end
