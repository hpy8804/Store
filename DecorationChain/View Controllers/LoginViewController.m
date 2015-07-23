//
//  LoginViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/1/28.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"
#import "ProfileModel.h"
#import "LoginModel.h"
#import "XPProgressHUD.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UIButton *signInButton;
@property (weak, nonatomic) IBOutlet UILabel *signInFailureText;

@property (strong, nonatomic) IBOutlet LoginViewModel *viewModel;

@end

@implementation LoginViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	self.title = @"登录";

	@weakify(self);
	[[self.cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext: ^(id x) {
	    @strongify(self);
	    [self dismissViewControllerAnimated:YES completion: ^{
		}];
	}];

//	RAC(self.signInButton, enabled) = [RACSignal combineLatest:@[self.usernameTextField.rac_textSignal, self.passwordTextField.rac_textSignal] reduce: ^id (NSString *username, NSString *password) {
//	    return @(username.length == 11 && password.length > 3);
//	}];
	[[[self.signInButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext: ^(id x) {
	    @strongify(self);
	    self.signInButton.enabled = NO;
	    [self.view endEditing:YES];
	    [XPProgressHUD showWithStatus:@"登录中..."];
	}]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [[self.viewModel signInSignal:self.usernameTextField.text password:self.passwordTextField.text]
	     subscribeNext: ^(LoginModel *x) {
	        if (x) {
	            [ProfileModel singleton].phone = self.usernameTextField.text;
	            [ProfileModel singleton].password = self.passwordTextField.text;
	            [ProfileModel singleton].model = [x copy];
	            [ProfileModel singleton].wasLogin = YES;
	            [[NSUserDefaults standardUserDefaults] setObject:self.usernameTextField.text forKey:@"id"];
	            [[NSUserDefaults standardUserDefaults] setObject:self.passwordTextField.text forKey:@"passwd"];
	            [[NSUserDefaults standardUserDefaults] synchronize];
	            [self dismissViewControllerAnimated:YES completion:nil];
			}
	        self.signInButton.enabled = YES;
	        [XPProgressHUD dismiss];
		}];
	}];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	if ([ProfileModel singleton].phone && [ProfileModel singleton].password) {
		self.usernameTextField.text = [ProfileModel singleton].phone;
		self.passwordTextField.text = [ProfileModel singleton].password;
	}
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

@end
