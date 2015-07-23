//
//  ProductInfoRatingTableViewCell.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RatingBar/RatingBar.h>
#import "BaseObject.h"
#import "ProductInfoModel.h"

@interface ProductInfoRatingTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet RatingBar *ratingBar;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;
@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;

- (void)updateWithModel:(ProductInfoCommentModel *)model;

@end
