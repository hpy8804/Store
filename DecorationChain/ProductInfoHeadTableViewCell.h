//
//  ProductInfoHeadTableViewCell.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XPADView.h"

@interface ProductInfoHeadTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet XPADView *adView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;

@end
