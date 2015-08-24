//
//  RegUserViewController.m
//  DecorationChain
//
//  Created by sven on 8/4/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "RegUserViewController.h"
#import "ProfileModel.h"
#import "ProvincePickViewController.h"

@interface RegUserViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNO;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (weak, nonatomic) IBOutlet UITextField *surePassword;
@property (weak, nonatomic) IBOutlet UITextField *QQ;
@property (weak, nonatomic) IBOutlet UITextField *company;
@property (weak, nonatomic) IBOutlet UITextField *subjectGroup;
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *distrct;
@property (weak, nonatomic) IBOutlet UITextField *detailAddress;
@property (weak, nonatomic) IBOutlet UIButton *distrctBtn;

@end

@implementation RegUserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.title = @"注册";
    
    [self.distrctBtn addTarget:self action:@selector(handleSelectDistrct) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)alertTips:(NSString *)strTip
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:strTip delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

-(BOOL) isValidateMobile:(NSString *)mobile
{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,5-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:mobile];
    
    return isMatch;
}

- (IBAction)handleRegister:(id)sender {
    if ([self.phoneNO.text length] == 0) {
        [self alertTips:@"手机号不能为空"];
        return;
    }
    
    if (![self isValidateMobile:self.phoneNO.text]) {
        [self alertTips:@"请输入正确的手机号码"];
        return;
    }
    if ([self.password.text length] == 0) {
        [self alertTips:@"密码不能为空"];
        return;
    }
    if (![self.surePassword.text isEqualToString:self.password.text]) {
        [self alertTips:@"两次输入密码不一致"];
        return;
    }
    if ([self.QQ.text length] == 0) {
        [self alertTips:@"QQ号不能为空"];
        return;
    }
    if ([self.company.text length] == 0) {
        [self alertTips:@"单位名称不能为空"];
        return;
    }
    if ([self.subjectGroup.text length] == 0) {
        [self alertTips:@"课题组名次不能为空"];
        return;
    }
    if ([self.name.text length] == 0) {
        [self alertTips:@"姓名不能为空"];
        return;
    }
    if ([self.distrct.text length] == 0) {
        [self alertTips:@"区域不能为空"];
        return;
    }
    if ([self.detailAddress.text length] == 0) {
        [self alertTips:@"详细地址不能为空"];
        return;
    }
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    NSDictionary *para = @{@"telephone":self.phoneNO.text,
                           @"password":self.password.text,
                           @"password1":self.surePassword.text,
                           @"company":self.company.text,
                           @"name":self.name.text,
                           @"qq":self.QQ.text,
                           @"provinceid":[[NSUserDefaults standardUserDefaults] objectForKey:@"province_id"],
                           @"cityid":[[NSUserDefaults standardUserDefaults] objectForKey:@"city_id"],
                           @"districtid":[[NSUserDefaults standardUserDefaults] objectForKey:@"district_id"],
                           @"address":self.detailAddress.text};
    [manager GET:@"http://122.114.61.234/app/api/account_register" parameters:para success:^(AFHTTPRequestOperation *operation, id responseObject) {
       
        if ([responseObject[@"msg"] isEqualToString:@"注册成功"]) {
            [ProfileModel singleton].wasLogin = YES;
            [ProfileModel singleton].phone = self.phoneNO.text;
            [ProfileModel singleton].password = self.password.text;
            LoginModel *model = [[LoginModel alloc] init];
            model.id = responseObject[@"date"][@"id"];
            model.name = responseObject[@"date"][@"username"];
            model.telephone = responseObject[@"date"][@"telephone"];
            model.password = responseObject[@"date"][@"password"];
            [ProfileModel singleton].model = [model copy];
//            [ProfileModel singleton].model.id = responseObject[@"date"][@"id"];
            [ProfileModel singleton].wasLogin = YES;
            [[NSUserDefaults standardUserDefaults] setObject:self.phoneNO.text forKey:@"id"];
            [[NSUserDefaults standardUserDefaults] setObject:self.password.text forKey:@"passwd"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self dismissViewControllerAnimated:YES completion:nil];
            
        }else{
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示"
                                                                message:responseObject[@"msg"]
                                                               delegate:nil
                                                      cancelButtonTitle:@"Ok"
                                                      otherButtonTitles:nil];
            [alertView show];
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

- (void)handleSelectDistrct
{
    ProvincePickViewController *viewController = (ProvincePickViewController *)[self instantiateViewControllerWithStoryboardName:@"MyAddress" identifier:@"MyProviceID"];
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    NSString *cacheProvince = [[NSUserDefaults standardUserDefaults] objectForKey:@"province_name"];
    NSString *cacheCity = [[NSUserDefaults standardUserDefaults] objectForKey:@"city_name"];
    NSString *cacheDistrict = [[NSUserDefaults standardUserDefaults] objectForKey:@"district_name"];
    if (cacheProvince && cacheCity && cacheDistrict) {
        [self.distrct setText:[NSString stringWithFormat:@"%@%@%@", cacheProvince, cacheCity, cacheDistrict]];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
