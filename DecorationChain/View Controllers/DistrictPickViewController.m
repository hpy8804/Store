//
//  DistrictViewController.m
//  DecorationChain
//
//  Created by huangxinping on 4/7/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "DistrictPickViewController.h"
#import "AreaPickViewModel.h"


#import "AddressDistrictModel.h"
#import "XPProgressHUD.h"

@interface DistrictPickViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet AreaPickViewModel *viewModel;
@property (nonatomic, strong) NSArray *districts;

@end

@implementation DistrictPickViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.tableView hideEmptySeparators];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[XPProgressHUD showWithStatus:@"加载中"];
	@weakify(self);
	[[self.viewModel districtsWithCityID:self.model.baseTransfer]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    self.districts = x;
	    [self.tableView reloadData];
	    [XPProgressHUD dismiss];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.districts.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	AddressDistrictModel *model = self.districts[indexPath.row];
	cell.textLabel.text = model.name;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];

	AddressDistrictModel *model = self.districts[indexPath.row];
	[[NSUserDefaults standardUserDefaults] setObject:model.id forKey:@"district_id"];
	[[NSUserDefaults standardUserDefaults] setObject:model.name forKey:@"district_name"];
	[[NSUserDefaults standardUserDefaults] synchronize];

	NSInteger targetIndex = self.navigationController.viewControllers.count - 4;
	[self.navigationController popToViewController:self.navigationController.viewControllers[targetIndex] animated:YES];
}

@end
