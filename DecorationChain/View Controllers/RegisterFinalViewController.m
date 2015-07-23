//
//  RegisterFinalViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/11.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "RegisterFinalViewController.h"
#import "RegisterViewModel.h"
#import "RegisterModel.h"
#import "ProfileModel.h"
#import "XPProgressHUD.h"

@interface RegisterFinalViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nickTextField;
@property (weak, nonatomic) IBOutlet UITextField *emailTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *password2Field;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet RegisterViewModel *viewModel;

@end

@implementation RegisterFinalViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = @"注册";

	[XPProgressHUD showWithStatus:@"加载中"];
	@weakify(self);
	[[[[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext: ^(id x) {
	    @strongify(self);
	    [self.view endEditing:YES];
	    self.submitButton.enabled = NO;
	    self.submitButton.hidden = YES;
	}] flattenMap: ^RACStream *(id value) {
	    @strongify(self);
	    if (!self.nickTextField.text.length) {
	        return [RACSignal return :[NSError errorWithDomain:@"请输入昵称" code:500 userInfo:nil]];
		}
	    if (self.nickTextField.text.length < 6 || self.nickTextField.text.length > 10) {
	        return [RACSignal return :[NSError errorWithDomain:@"昵称长度为6-10位" code:500 userInfo:nil]];
		}
	    else if (!self.passwordTextField.text.length) {
	        return [RACSignal return :[NSError errorWithDomain:@"请输入密码" code:500 userInfo:nil]];
		}
	    else if (self.passwordTextField.text.length < 6 || self.passwordTextField.text.length > 10) {
	        return [RACSignal return :[NSError errorWithDomain:@"密码长度为6-10位" code:500 userInfo:nil]];
		}
	    else if (![self.passwordTextField.text isEqualToString:self.password2Field.text]) {
	        return [RACSignal return :[NSError errorWithDomain:@"两次输入密码不一致" code:500 userInfo:nil]];
		}
	    else {
	        return [self.viewModel registerWithName:self.nickTextField.text email:self.emailTextField.text phone:self.model.baseTransfer password:self.passwordTextField.text];
		}
	}] subscribeNext: ^(id x) {
	    @strongify(self);
	    if ([x isKindOfClass:[NSError class]]) {
	        self.submitButton.enabled = YES;
	        self.submitButton.hidden = NO;
	        ALERT([(NSError *)x domain]);
		}
	    else if ([x isKindOfClass:[RegisterModel class]]) {
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
