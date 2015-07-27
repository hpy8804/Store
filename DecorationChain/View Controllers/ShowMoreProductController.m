//
//  ShowMoreProductController.m
//  DecorationChain
//
//  Created by sven on 7/27/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "ShowMoreProductController.h"

@interface ShowMoreProductController ()

@end

@implementation ShowMoreProductController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"特色产品";
    [self.tableView addHeaderWithCallback:^{
        [self obtainMoreProducts];
    }];
    
    [self.tableView headerBeginRefreshing];
}

- (void)obtainMoreProducts
{
    self.mutListMore = [NSMutableArray array];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager GET:@"http://122.114.61.234/app/api/more_special" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        // 3
        //[self.view setAnimatingWithStateOfOperation:operation];
        
        NSArray *carsList = responseObject[@"data"];
        for (int i = 0; i < carsList.count; i++) {
            ProductModel *model = [[ProductModel alloc] init];
            model.proId = carsList[i][@"id"];
            model.en_name = carsList[i][@"en_name"];
            model.cas = carsList[i][@"cas"];
            model.formula = carsList[i][@"formula"];
            model.name = carsList[i][@"name"];
            [self.mutListMore addObject:model];
        }
        
        [self.tableView headerEndRefreshing];
        [self.tableView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        // 4
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 129.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mutListMore.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"showMoreProductCell";
    BOOL nibsRegistered = NO;
    if (!nibsRegistered) {
        UINib *nib = [UINib nibWithNibName:@"ProductProfileTableViewCell" bundle:nil];
        [tableView registerNib:nib forCellReuseIdentifier:CellIdentifier];
        nibsRegistered = YES;
    }
    ProductProfileTableViewCell *cell = (ProductProfileTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (self.mutListMore.count > 0) {
        cell.productModel = self.mutListMore[indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
}

@end
