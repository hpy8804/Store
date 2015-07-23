//
//  KindSubProductView.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "KindSubProductView.h"

#import "NSString+imageurl.h"

#import <XPKit/XPKit.h>
#import <XPToast/XPToast.h>
#import "KindGroupViewController.h"

@implementation KindSubProductView

- (void)updateWithModel:(KindSubProductModel *)model {
	[self.logoImageView setImageUrl:[model.image fullImageURL]];
	self.nameLabel.text = model.name;

	@weakify(self);
	[self.logoImageView whenTapped: ^{
	    @strongify(self);
	    BaseViewController *belongViewController = (BaseViewController *)[self belongViewController];
	    BaseViewController *viewController = (BaseViewController *)[belongViewController instantiateInitialViewControllerWithStoryboardName:@"KindGroup"];
	    viewController.model = [BaseObject new];
	    viewController.model.identifier = model.id;
	    viewController.model.baseTransfer = model.name;
	    [belongViewController.navigationController pushViewController:viewController animated:YES];
	}];
}

@end
