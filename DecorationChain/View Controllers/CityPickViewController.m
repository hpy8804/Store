//
//  CityViewController.m
//  DecorationChain
//
//  Created by huangxinping on 4/7/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "CityPickViewController.h"
#import "AreaPickViewModel.h"

#import "AddressCityModel.h"
#import "XPProgressHUD.h"

@interface CityPickViewController ()

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet AreaPickViewModel *viewModel;
@property (nonatomic, strong) NSArray *citys;

@end

@implementation CityPickViewController

- (void)viewDidLoad {
	[super viewDidLoad];

	[self.tableView hideEmptySeparators];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];

	[XPProgressHUD showWithStatus:@"加载中"];
	@weakify(self);
	[[self.viewModel citysWithProvinceID:self.model.baseTransfer]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    self.citys = x;
	    [self.tableView reloadData];
	    [XPProgressHUD dismiss];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

#pragma mark - tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return self.citys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
	AddressCityModel *model = self.citys[indexPath.row];
	cell.textLabel.text = model.name;
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - perform
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ([segue.identifier isEqualToString:@"embed_district"]) {
		NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
		BaseViewController *viewController = segue.destinationViewController;
		viewController.model = [[BaseObject alloc] init];
		AddressCityModel *model = self.citys[selectedIndexPath.row];
		viewController.model.baseTransfer = model.id;

		[[NSUserDefaults standardUserDefaults] setObject:model.id forKey:@"city_id"];
		[[NSUserDefaults standardUserDefaults] setObject:model.name forKey:@"city_name"];
		[[NSUserDefaults standardUserDefaults] setObject:model.zipcode forKey:@"zipcode"];
		[[NSUserDefaults standardUserDefaults] synchronize];
	}
}

@end
