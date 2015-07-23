//
//  RepasswordFinalViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/7/22.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "RepasswordFinalViewController.h"
#import "RepasswordViewModel.h"
#import "XPProgressHUD.h"
#import "ProfileModel.h"

@interface RepasswordFinalViewController ()

@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *password2Field;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet RepasswordViewModel *viewModel;

@end

@implementation RepasswordFinalViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = @"忘记密码";

	[XPProgressHUD showWithStatus:@"加载中"];
	@weakify(self);
	[[[[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext: ^(id x) {
	    @strongify(self);
	    [self.view endEditing:YES];
	    self.submitButton.enabled = NO;
	    self.submitButton.hidden = YES;
	}] flattenMap: ^RACStream *(id value) {
	    @strongify(self);
	    if (!self.passwordTextField.text.length) {
	        return [RACSignal return :[NSError errorWithDomain:@"请输入密码" code:500 userInfo:nil]];
		}
	    else if (self.passwordTextField.text.length < 6 || self.passwordTextField.text.length > 10) {
	        return [RACSignal return :[NSError errorWithDomain:@"密码长度为6-10位" code:500 userInfo:nil]];
		}
	    else if (![self.passwordTextField.text isEqualToString:self.password2Field.text]) {
	        return [RACSignal return :[NSError errorWithDomain:@"两次输入密码不一致" code:500 userInfo:nil]];
		}
	    else {
	        return [self.viewModel repasswordWithName:self.model.baseTransfer password:self.passwordTextField.text];
		}
	}] subscribeNext: ^(id x) {
	    @strongify(self);
	    if ([x isKindOfClass:[NSError class]]) {
	        self.submitButton.enabled = YES;
	        self.submitButton.hidden = NO;
	        ALERT([(NSError *)x domain]);
		}
	    else if ([x isKindOfClass:[NSNumber class]] &&
	             [x boolValue]) {
	        [ProfileModel singleton].phone = self.model.baseTransfer;
	        [ProfileModel singleton].password = self.passwordTextField.text;
	        [self.navigationController popToRootViewControllerAnimated:YES];
		}
	    [XPProgressHUD dismiss];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
