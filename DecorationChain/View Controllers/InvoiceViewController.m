//
//  InvoiceViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/21.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "InvoiceViewController.h"
#import "RuntimeCacheModel.h"

@interface InvoiceViewController ()

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (weak, nonatomic) IBOutlet UITextField *invoiceNameTextField;

@end

@implementation InvoiceViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	@weakify(self);
	[[self.saveButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self.navigationController popViewControllerAnimated:YES];
	}];
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[RuntimeCacheModel singleton].invoiceName = self.invoiceNameTextField.text;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
