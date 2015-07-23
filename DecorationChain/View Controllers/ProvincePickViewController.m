//
//  ProvincePickViewController.m
//  DecorationChain
//
//  Created by huangxinping on 4/7/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "ProvincePickViewController.h"
#import "AreaPickViewModel.h"

#import "AddressProvinceModel.h"
#import "XPProgressHUD.h"

@interface ProvincePickViewController () <UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet AreaPickViewModel *viewModel;
@property (nonatomic, strong) NSArray *provinces;
@end

@implementation ProvincePickViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.tableView hideEmptySeparators];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[XPProgressHUD showWithStatus:@"加载中"];
	@weakify(self);
	[[self.viewModel provinces]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    self.provinces = x;
	    [self.tableView reloadData];
	    [XPProgressHUD dismiss];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.provinces.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	AddressProvinceModel *model = self.provinces[indexPath.row];
	cell.textLabel.text = model.name;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - perform
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embed_city"]) {
		NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
		BaseViewController *viewController = segue.destinationViewController;
		viewController.model = [[BaseObject alloc] init];
		AddressProvinceModel *model = self.provinces[selectedIndexPath.row];
		viewController.model.baseTransfer = model.id;

		[[NSUserDefaults standardUserDefaults] setObject:model.id forKey:@"province_id"];
		[[NSUserDefaults standardUserDefaults] setObject:model.name forKey:@"province_name"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

@end
