//
//  ProductItemCollectionViewCell.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/18.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductItemModel.h"
#import <LASIImageView/LASIImageView.h>

@interface ProductItemCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet LASIImageView *logoImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;

@property (nonatomic, strong) ProductItemModel *itemModel;

@end
