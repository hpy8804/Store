//
//  OrderScoreViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/7/22.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "OrderScoreViewController.h"
#import <UITextView+Placeholder/UITextView+Placeholder.h>
#import <RatingBar/RatingBar.h>
#import "XPProgressHUD.h"
#import "OrderInfoModel.h"
#import "MyOrderViewModel.h"

@interface OrderScoreViewController ()

@property (weak, nonatomic) IBOutlet RatingBar *ratingBar;
@property (weak, nonatomic) IBOutlet UITextView *contentTextView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet MyOrderViewModel *viewModel;

@end

@implementation OrderScoreViewController

- (void)viewDidLoad {
	[super viewDidLoad];


	self.ratingBar.starNumber = 5;
	self.ratingBar.enable = YES;
	self.ratingBar.backgroundColor = [UIColor clearColor];

	self.contentTextView.placeholder = @"请输入...";

	@weakify(self);
	[[[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext: ^(id x) {
	    @strongify(self);
	    [self.submitButton setEnabled:NO];
	}]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self scoreOrder];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)scoreOrder {
	[XPProgressHUD showWithStatus:@"加载中"];

	OrderInfoModel *infoModel = (OrderInfoModel *)self.model;
	NSString *productIDs = @"";
	for (NSInteger i = 0; i < infoModel.contents.count; i++) {
		OrderInfoContentModel *content = infoModel.contents[i];
		productIDs = [productIDs stringByAppendingString:content.id];
		productIDs = [productIDs stringByAppendingString:@","];
	}

	[[self.viewModel orderScoreWithOrderID:infoModel.id accountID:infoModel.accountId productID:productIDs commentClass:self.ratingBar.starNumber content:self.contentTextView.text] subscribeNext: ^(id x) {
	    [XPProgressHUD dismiss];

	    [self.navigationController popViewControllerAnimated:YES];
	}];
}

@end
