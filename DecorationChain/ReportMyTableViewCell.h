//
//  ReportMyTableViewCell.h
//  DecorationChain
//
//  Created by huangxinping on 15/5/29.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReportStoreModel;
@interface ReportMyTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *selectButton;

@property (nonatomic, assign) NSInteger number;
@property (nonatomic, assign) BOOL selectedReport;

- (void)updateWithModel:(ReportStoreModel *)model;

@end
