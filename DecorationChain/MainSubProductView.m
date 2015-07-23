//
//  MainSubProductView.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/13.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "MainSubProductView.h"
#import <MarkupLabel/UILabel+MarkupExtensions.h>
#import <LASIImageView/LASIImageView.h>
#import "NSString+imageurl.h"
#import "ProductInfoViewController.h"

@interface MainSubProductView ()

@property (weak, nonatomic) IBOutlet LASIImageView *productImageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *nowPriceLabel;
@property (weak, nonatomic) IBOutlet UILabel *oldPriceLabel;
@property (weak, nonatomic) IBOutlet UIButton *clickButton;

@end

@implementation MainSubProductView

- (void)awakeFromNib {
}

- (void)updateWithModel:(ProductItemModel *)model {
	self.titleLabel.text = model.name;
	self.nowPriceLabel.text = [NSString stringWithFormat:@"￥%@", model.saleprice];
	[self.oldPriceLabel setMarkup:[NSString stringWithFormat:@"<strike>￥%@</strike>", model.price]];
	[self.productImageView setImageUrl:[model.images fullImageURL]];

	[[self.clickButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    BaseViewController *belongViewController = (BaseViewController *)[self belongViewController];
	    BaseViewController *viewController = (BaseViewController *)[belongViewController instantiateInitialViewControllerWithStoryboardName:@"ProductInfo"];
	    viewController.model = [BaseObject new];
	    viewController.model.identifier = model.id;
	    [belongViewController.navigationController pushViewController:viewController animated:YES];
	}];
}

@end
