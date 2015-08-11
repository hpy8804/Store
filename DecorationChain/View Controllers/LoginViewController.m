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
#import "RegUserViewController.h"

@interface LoginViewController ()<UIAlertViewDelegate>

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
- (IBAction)forgetPasswordAction:(id)sender {
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]])
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"立刻联系QQ客服号：123456" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:nil message:@"请先安装QQ，方便与我们取得联系，或者使用其他方式联系我们（QQ客服号：123456）" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
}
- (IBAction)registerAction:(id)sender {
    RegUserViewController *vcRegUser = [[RegUserViewController alloc] initWithNibName:@"RegUserViewController" bundle:nil];
    [self.navigationController pushViewController:vcRegUser animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"mqq://"]];
    }
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
