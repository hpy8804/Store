//
//  PaymentAndDeliveryViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/21.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "PaymentAndDeliveryViewController.h"
#import <XPKit/XPKit.h>
#import "RuntimeCacheModel.h"

@interface PaymentAndDeliveryViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *payCrossImageView;
@property (weak, nonatomic) IBOutlet UIImageView *getCrossImageView;
@property (weak, nonatomic) IBOutlet UIButton *onlinePayButton;
@property (weak, nonatomic) IBOutlet UIButton *offlinePayButton;
@property (weak, nonatomic) IBOutlet UIButton *expressButton;
@property (weak, nonatomic) IBOutlet UIButton *himButton;
@property (weak, nonatomic) IBOutlet UIButton *saveButton;

@end

@implementation PaymentAndDeliveryViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	@weakify(self);
	[[self.onlinePayButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self.onlinePayButton setSelected:YES];
	    [self.offlinePayButton setSelected:NO];
	    self.payCrossImageView.left = 128;
	}];
	[[self.offlinePayButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self.onlinePayButton setSelected:NO];
	    [self.offlinePayButton setSelected:YES];
	    self.payCrossImageView.left = 298;
	}];
	[[self.expressButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self.expressButton setSelected:YES];
	    [self.himButton setSelected:NO];
	    self.getCrossImageView.left = 128;
	}];
	[[self.himButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self.expressButton setSelected:NO];
	    [self.himButton setSelected:YES];
	    self.getCrossImageView.left = 298;
	}];

	[[self.saveButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self.navigationController popViewControllerAnimated:YES];
	}];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[RuntimeCacheModel singleton].payment = self.onlinePayButton.selected ? @"1" : @"2";
	[RuntimeCacheModel singleton].shipment = self.expressButton.selected ? @"1" : @"2";
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
