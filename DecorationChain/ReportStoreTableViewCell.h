//
//  ReportStoreTableViewCell.h
//  DecorationChain
//
//  Created by huangxinping on 15/5/28.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ReportStoreModel;
@interface ReportStoreTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger number;

- (void)updateWithModel:(ReportStoreModel *)model;

@end
