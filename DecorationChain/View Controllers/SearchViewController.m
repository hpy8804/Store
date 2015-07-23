//
//  SearchViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/13.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITextField *searchTextField;

@end

@implementation SearchViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	@weakify(self);
	[[self.backButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self dismissViewControllerAnimated:YES completion:nil];
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationController.navigationBar.hidden = YES;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - textfield
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
	[self.view endEditing:YES];

	if ([textField.text isEqualToString:@""]) {
		[XPToast showWithText:@"查询关键字不能为空"];
		return NO;
	}

	{ // 保存到本地
		NSMutableArray *buffer = [NSMutableArray arrayWithContentsOfFile:[[NSFileManager documentsDirectory] stringByAppendingPathComponent:@"history"]];
		if (!buffer) {
			buffer = [NSMutableArray array];
		}
		[buffer addObject:textField.text];
		[buffer writeToFile:[[NSFileManager documentsDirectory] stringByAppendingPathComponent:@"history"] atomically:YES];
	}

	[self performSegueWithIdentifier:@"embed_result" sender:self context:textField.text];
	return YES;
}

#pragma mark - prepare
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embed_result"]) {
		NSString *key = segue.context;
		BaseViewController *viewController = (BaseViewController *)segue.destinationViewController;
		BaseObject *bo = [BaseObject new];
		bo.baseTransfer = key;
		viewController.model = bo;
	}
}

@end
