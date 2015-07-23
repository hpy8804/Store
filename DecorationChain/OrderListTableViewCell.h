//
//  OrderListTableViewCell.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/14.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderListModel.h"

// 我的订单
@interface OrderListTableViewCell : UITableViewCell

- (void)updateWithModel:(OrderListModel *)model;

@end
