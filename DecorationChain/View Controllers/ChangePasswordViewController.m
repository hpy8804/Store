//
//  ChangePasswordViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/13.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ChangePasswordViewController.h"
#import "ProfileModel.h"
#import "PasswordTableViewCell.h"
#import "ChangePasswordViewModel.h"
#import "XPProgressHUD.h"

@interface ChangePasswordViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UILabel *nickLabel;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet ChangePasswordViewModel *viewModel;

@end

@implementation ChangePasswordViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	RAC(self.nickLabel, text) = RACObserve([ProfileModel singleton].model, name);

	@weakify(self);
	[[[[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext: ^(id x) {
	    @strongify(self);
	    [XPProgressHUD showWithStatus:@"加载中"];
	    self.submitButton.enabled = NO;
	    [self.view endEditing:YES];
	}] flattenMap: ^RACStream *(id value) {
	    return [self validInput];
	}] subscribeNext: ^(NSNumber *x) {
	    if (x.boolValue) {
	        PasswordTableViewCell *cell0 = (PasswordTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	        PasswordTableViewCell *cell1 = (PasswordTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	        [[self.viewModel updatePasswordWithPhone:[ProfileModel singleton].phone oldPassword:cell0.passwordTextField.text newPassword:cell1.passwordTextField.text]
	         subscribeNext: ^(id x) {
	            if (x) {
	                [XPToast showWithText:@"密码修改成功"];
				}
	            [self.navigationController popViewControllerAnimated:YES];
			}];
		}
	    [XPProgressHUD dismiss];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (RACSignal *)validInput {
	return [RACSignal createSignal: ^RACDisposable *(id < RACSubscriber > subscriber) {
	    PasswordTableViewCell *cell0 = (PasswordTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	    PasswordTableViewCell *cell1 = (PasswordTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	    PasswordTableViewCell *cell2 = (PasswordTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
	    if (cell0.passwordTextField.text.length > 3 &&
	        cell1.passwordTextField.text.length > 3 &&
	        [cell2.passwordTextField.text isEqualToString:cell1.passwordTextField.text]) {
	        [subscriber sendNext:@(1)];
	        [subscriber sendCompleted];
		}
	    else {
	        [XPToast showWithText:@"资料填写不正确"];
	        [subscriber sendNext:@(0)];
	        [subscriber sendCompleted];
		}
	    return [RACDisposable disposableWithBlock: ^{
		}];
	}];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell_%ld", indexPath.row] forIndexPath:indexPath];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
