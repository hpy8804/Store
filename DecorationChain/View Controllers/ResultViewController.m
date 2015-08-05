//
//  ResultViewController.m
//  DecorationChain
//
//  Created by sven on 7/27/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "ResultViewController.h"
#import "ProductProfileTableViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "XPProgressHUD.h"

@interface ResultViewController ()
@property (weak, nonatomic) IBOutlet UITableView *searchListTableView;
@property (strong, nonatomic) NSMutableArray *mutList;

@property (nonatomic, copy) NSString *strCategory;
@property (nonatomic, copy) NSString *strKeyWord;
@property (weak, nonatomic) IBOutlet UILabel *tipLabel;
@property (assign, nonatomic) NSInteger page;
@end

@implementation ResultViewController

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithCategory:(NSString *)category keyWord:(NSString *)keyWord
{
    if (self = [super init]) {
        self.strCategory = category;
        self.strKeyWord = keyWord;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"搜索";
    [self obtainMoreProducts];
    [self.searchListTableView addFooterWithCallback:^{
        [self obtainMoreSearchResult];
    }];
}

- (void)obtainMoreProducts
{
    [XPProgressHUD showWithStatus:@"加载中"];
    self.searchListTableView.hidden = YES;
    self.mutList = [NSMutableArray array];
    self.page = 1;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSInteger type = 1;
    if ([self.strCategory isEqualToString:@"CAS"]) {
        type = 1;
    }else if ([self.strCategory isEqualToString:@"中文"]){
        type = 2;
        
    }else if ([self.strCategory isEqualToString:@"英文"]){
        type = 3;
        
    }else if ([self.strCategory isEqualToString:@"分子式"]){
        type = 4;
        
    }
    [manager GET:@"http://122.114.61.234/app/api/more_special" parameters:@{@"type":@(type),
                                                                            @"page":@(self.page),
                                                                            @"title":self.strKeyWord}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
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
            [self.mutList addObject:model];
        }
        
        [XPProgressHUD dismiss];
        if (self.mutList.count == 0) {
            self.tipLabel.hidden = NO;
        }else{
            self.searchListTableView.hidden = NO;
            [self.searchListTableView reloadData];
        }
        
        
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

- (void)obtainMoreSearchResult
{
    self.page++;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSInteger type = 1;
    if ([self.strCategory isEqualToString:@"CAS"]) {
        type = 1;
    }else if ([self.strCategory isEqualToString:@"中文"]){
        type = 2;
        
    }else if ([self.strCategory isEqualToString:@"英文"]){
        type = 3;
        
    }else if ([self.strCategory isEqualToString:@"分子式"]){
        type = 4;
        
    }
    [manager GET:@"http://122.114.61.234/app/api/more_special" parameters:@{@"type":@(type),
                                                                            @"page":@(self.page),
                                                                            @"title":self.strKeyWord}
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             
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
                 [self.mutList addObject:model];
             }
             
             [self.searchListTableView footerEndRefreshing];
             [self.searchListTableView reloadData];
             
             
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 129.0f;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.mutList.count;
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
    if (self.mutList.count > 0) {
        cell.productModel = self.mutList[indexPath.row];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    BaseViewController *viewController = (BaseViewController *)[self instantiateInitialViewControllerWithStoryboardName:@"ProductInfo"];
    viewController.model = [BaseObject new];
    
    ProductModel *model = self.mutList[indexPath.row];
    viewController.model.identifier = model.proId;
    [self.navigationController pushViewController:viewController animated:YES];
    
}
@end
