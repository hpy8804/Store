//
//  AddressTableViewCell.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddressModel.h"

@interface AddressTableViewCell : UITableViewCell

- (void)updateWithModel:(AddressModel *)model;

@end
