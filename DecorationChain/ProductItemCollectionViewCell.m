//
//  ProductItemCollectionViewCell.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/18.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ProductItemCollectionViewCell.h"
#import <UILabel+MarkupExtensions.h>
#import "NSString+imageurl.h"

@interface ProductItemCollectionViewCell ()


@end

@implementation ProductItemCollectionViewCell

- (void)setItemModel:(ProductItemModel *)itemModel {
	self.nameLabel.text = itemModel.name;
	self.nowPriceLabel.text = [NSString stringWithFormat:@"￥%@", itemModel.saleprice];
	[self.oldPriceLabel setMarkup:[NSString stringWithFormat:@"<strike>￥%@</strike>", !itemModel.price?@"0.0":itemModel.price]];
	[self.logoImageView setImageUrl:[itemModel.images fullImageURL]];
}

@end
