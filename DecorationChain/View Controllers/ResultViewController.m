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
}

- (void)obtainMoreProducts
{
    [XPProgressHUD showWithStatus:@"加载中"];
    self.searchListTableView.hidden = YES;
    self.mutList = [NSMutableArray array];
    
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
            
            if ([self.strCategory isEqualToString:@"CAS"]) {
                if ([model.cas rangeOfString:self.strKeyWord].length != 0) {
                    [self.mutList addObject:model];
                }
            }else if ([self.strCategory isEqualToString:@"中文"]){
                if ([model.name rangeOfString:self.strKeyWord].length != 0) {
                    [self.mutList addObject:model];
                }
                
            }else if ([self.strCategory isEqualToString:@"英文"]){
                if ([model.en_name rangeOfString:self.strKeyWord].length != 0) {
                    [self.mutList addObject:model];
                }
                
            }else if ([self.strCategory isEqualToString:@"分子式"]){
                if ([model.formula rangeOfString:self.strKeyWord].length != 0) {
                    [self.mutList addObject:model];
                }
                
            }
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
    
}
@end
