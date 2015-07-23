//
//  EditAddressViewController.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/14.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "EditAddressViewController.h"

#import <XPToast/XPToast.h>

#import <AddressBookUI/AddressBookUI.h>

#import "AddressModel.h"
#import "MyAddressViewModel.h"
#import "ProfileModel.h"

#import <CSNNotificationObserver/CSNNotificationObserver.h>
#import <UITextView+Placeholder/UITextView+Placeholder.h>
#import "XPProgressHUD.h"

@interface EditAddressViewController () <ABPeoplePickerNavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIButton *getLocalContactButton;
@property (weak, nonatomic) IBOutlet UITextField *nameTextFiled;
@property (weak, nonatomic) IBOutlet UITextField *phoneTextField;
@property (weak, nonatomic) IBOutlet UIButton *addressButton;
@property (weak, nonatomic) IBOutlet UITextView *infoTextView;

@property (weak, nonatomic) IBOutlet UIButton *saveButton;
@property (strong, nonatomic) IBOutlet MyAddressViewModel *viewModel;

@end

@implementation EditAddressViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	if (self.model) {
		self.title = @"修改收货地址";

		AddressModel *_model = (AddressModel *)self.model;
		self.nameTextFiled.text = _model.recipientsName;
		self.phoneTextField.text = _model.telephone;
		if (_model.province && _model.city && _model.district) {
			[self.addressButton setTitle:[NSString stringWithFormat:@"%@-%@-%@", _model.province, _model.city, _model.district] forState:UIControlStateNormal];
		}
		if (_model.address) {
			self.infoTextView.text = _model.address;
		}


		[[NSUserDefaults standardUserDefaults] setObject:_model.provinceid forKey:@"province_id"];
		[[NSUserDefaults standardUserDefaults] setObject:_model.cityid forKey:@"city_id"];
		[[NSUserDefaults standardUserDefaults] setObject:_model.districtid forKey:@"district_id"];
		[[NSUserDefaults standardUserDefaults] setObject:_model.zipcode forKey:@"zipcode"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
	else {
		self.title = @"新增收货地址";
	}

	@weakify(self);
	[[self.getLocalContactButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self readLocalAddressbook];
	}];

	[[[[[self.saveButton rac_signalForControlEvents:UIControlEventTouchUpInside] doNext: ^(id x) {
	    @strongify(self);
	    self.saveButton.enabled = NO;
	}] map: ^id (id value) {
	    if ([self.nameTextFiled.text isEqualToString:@""] ||
	        [self.nameTextFiled.text isEqualToString:@"请输入收货人"]) {
	        [XPToast showWithText:@"请输入收货人"];
	        self.saveButton.enabled = YES;
	        return @(0);
		}
	    if ([self.phoneTextField.text isEqualToString:@""] ||
	        [self.phoneTextField.text isEqualToString:@"请输入联系方式"]) {
	        [XPToast showWithText:@"请输入联系方式"];
	        self.saveButton.enabled = YES;
	        return @(0);
		}
	    if ([self.addressButton.currentTitle isEqualToString:@""] ||
	        [self.addressButton.currentTitle isEqualToString:@"请选择"]) {
	        [XPToast showWithText:@"请选择收货区域"];
	        self.saveButton.enabled = YES;
	        return @(0);
		}
	    if ([self.infoTextView.text isEqualToString:@""] ||
	        [self.infoTextView.text isEqualToString:@"请输入"]) {
	        [XPToast showWithText:@"请输入详细地址"];
	        self.saveButton.enabled = YES;
	        return @(0);
		}
	    return @(1);
	}] ignore:@(0)]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [XPProgressHUD showWithStatus:@"加载中"];
	    NSString *provinceID = [[NSUserDefaults standardUserDefaults] objectForKey:@"province_id"];
	    NSString *cityID = [[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"];
	    NSString *districtID = [[NSUserDefaults standardUserDefaults] objectForKey:@"district_id"];
	    NSString *zipcode = [[NSUserDefaults standardUserDefaults] objectForKey:@"zipcode"];
	    if (self.model) {
	        [[self.viewModel editAddressWithID:[ProfileModel singleton].model.id addressID:[(AddressModel *)self.model id] recipientsName:self.nameTextFiled.text province:provinceID city:cityID district:districtID address:self.infoTextView.text zipcode:zipcode telephone:self.phoneTextField.text mobilePhone:nil email:nil signBuilding:nil isDefault:0]
	         subscribeNext: ^(id x) {
	            @strongify(self);
	            if (x) {
	                [XPToast showWithText:@"编辑收货地址成功"];
	                [self.navigationController popViewControllerAnimated:YES];
				}
	            [XPProgressHUD dismiss];
	            self.saveButton.enabled = YES;
			}];
		}
	    else {
	        [[self.viewModel addAddressWithID:[ProfileModel singleton].model.id recipientsName:self.nameTextFiled.text provinceID:provinceID cityID:cityID districtID:districtID address:self.infoTextView.text zipcode:zipcode telephone:self.phoneTextField.text mobilePhone:nil email:nil signBuilding:nil isDefault:0]
	         subscribeNext: ^(id x) {
	            @strongify(self);
	            if (x) {
	                [XPToast showWithText:@"新增收货地址成功"];
	                [self.navigationController popViewControllerAnimated:YES];
				}
	            [XPProgressHUD dismiss];
	            self.saveButton.enabled = YES;
			}];
		}
	}];

	self.infoTextView.placeholder = @"请输入";
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	NSString *cacheProvince = [[NSUserDefaults standardUserDefaults] objectForKey:@"province_name"];
	NSString *cacheCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"city_name"];
	NSString *cacheDistrict = [[NSUserDefaults standardUserDefaults] objectForKey:@"district_name"];
	if (cacheProvince && cacheCity && cacheDistrict) {
		[self.addressButton setTitle:[NSString stringWithFormat:@"%@-%@-%@", cacheProvince, cacheCity, cacheDistrict] forState:UIControlStateNormal];
	}
}

- (void)viewWillDisappear:(BOOL)animated {
	[super viewWillDisappear:animated];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"province_name"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"city_name"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"district_name"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"province_id"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"city_id"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"district_id"];
	[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"zipcode"];
	[[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - location addressbook
- (void)readLocalAddressbook {
	ABPeoplePickerNavigationController *picker =
	    [[ABPeoplePickerNavigationController alloc] init];
	picker.peoplePickerDelegate = self;
	[self presentViewController:picker animated:YES completion: ^{
	}];
}

#pragma mark - People picker delegate
- (void)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker didSelectPerson:(ABRecordRef)person {
	//获取联系人姓名
	self.nameTextFiled.text = (__bridge NSString *)ABRecordCopyCompositeName(person);
	//获取联系人电话
	ABMutableMultiValueRef phoneMulti = ABRecordCopyValue(person, kABPersonPhoneProperty);
	NSMutableArray *phones = [[NSMutableArray alloc] init];
	for (NSInteger i = 0; i < ABMultiValueGetCount(phoneMulti); i++) {
		NSString *aPhone = (__bridge NSString *)ABMultiValueCopyValueAtIndex(phoneMulti, i);
		NSString *aLabel = (__bridge NSString *)ABMultiValueCopyLabelAtIndex(phoneMulti, i);
		if ([aLabel isEqualToString:@"_$!<Mobile>!$_"]) {
			[phones addObject:aPhone];
		}
	}
	if ([phones count] > 0) {
		NSString *mobileNo = [phones objectAtIndex:0];
		self.phoneTextField.text = mobileNo;
	}

	[peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

@end
