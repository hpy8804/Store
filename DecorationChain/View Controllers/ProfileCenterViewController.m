//
//  ProfileCenterViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/13.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ProfileCenterViewController.h"
#import "ProfileCenterViewModel.h"
#import "ProfileModel.h"

#import "AvatarTableViewCell.h"
#import "NickTableViewCell.h"
#import "EmailTableViewCell.h"
#import "PhoneTableViewCell.h"

#import <BlocksKit/UIImagePickerController+BlocksKit.h>
#import "XPProgressHUD.h"

@interface ProfileCenterViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;
@property (strong, nonatomic) IBOutlet ProfileCenterViewModel *viewModel;

@end

@implementation ProfileCenterViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	@weakify(self);
	[[[self.submitButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext: ^(id x) {
	    [self.submitButton setEnabled:NO];
	    [XPProgressHUD showWithStatus:@"加载中"];
	    [self.view endEditing:YES];
	}]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    NickTableViewCell *cell1 = (NickTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
	    EmailTableViewCell *cell2 = (EmailTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
	    PhoneTableViewCell *cell3 = (PhoneTableViewCell *)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
	    [[self.viewModel updateProfileWithID:[ProfileModel singleton].model.id name:cell1.nickTextField.text email:cell2.mailTextField.text telephone:cell3.phoneTextField.text avatarURL:[ProfileModel singleton].model.personPic]
	     subscribeNext: ^(NSDictionary *x) {
	        if (x) {
	            if (x[@"email"]) {
	                [ProfileModel singleton].model.email = x[@"email"];
				}
	            if (x[@"name"]) {
	                [ProfileModel singleton].model.name = x[@"name"];
				}
	            if (x[@"person_pic"]) {
	                [ProfileModel singleton].model.personPic = x[@"person_pic"];
				}
	            if (x[@"telephone"]) {
	                [ProfileModel singleton].model.telephone = x[@"telephone"];
				}
	            [ProfileModel singleton].wasLogin = YES;
	            [XPToast showWithText:@"资料修改成功"];
	            [self.navigationController popViewControllerAnimated:YES];
			}
	        [self.submitButton setEnabled:YES];
	        [XPProgressHUD dismiss];
		}];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[NSString stringWithFormat:@"Cell_%ld", indexPath.row] forIndexPath:indexPath];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
	switch (indexPath.row) {
		case 0:
		{
			[UIActionSheet actionSheetWithTitle:nil message:nil destructiveButtonTitle:nil cancelButtonTitle:@"取消" buttons:@[@"相册", @"拍照"] showInView:self.view onDismiss: ^(NSInteger buttonIndex, NSString *buttonTitle) {
			    [self imagePickerWithType:buttonIndex];
			} onCancel: ^{
			}];
			break;
		}

		default:
			break;
	}
}

#pragma mark - ImagePicker
- (void)imagePickerWithType:(NSInteger)type {
	UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
	imagePicker.sourceType = type ? UIImagePickerControllerSourceTypeCamera : UIImagePickerControllerSourceTypePhotoLibrary;
	imagePicker.allowsEditing = YES;
	@weakify(self);
	[imagePicker setBk_didFinishPickingMediaBlock: ^(UIImagePickerController *_imagePicker, NSDictionary *info) {
	    @strongify(self);
	    UIImage *edit = [info objectForKey:UIImagePickerControllerEditedImage];
	    [self dismissViewControllerAnimated:_imagePicker completion:nil];
	    [XPProgressHUD showWithStatus:@"正在上传头像"];
	    [[self.viewModel updateAvatarWithID:nil image:edit]
	     subscribeNext: ^(NSNumber *x) {
	        if (x.integerValue) {
	            [XPToast showWithText:@"头像更新成功"];
			}
	        [XPProgressHUD dismiss];
		}];
	}];
	[self presentViewController:imagePicker animated:YES completion:nil];
}

@end
