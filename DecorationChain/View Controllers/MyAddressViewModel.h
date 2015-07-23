//
//  MyAddressViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"

@interface MyAddressViewModel : BaseViewModel

/**
 *  获取收货地址列表
 *
 *  @param identifier 用户ID
 *  @param page       页码
 *
 *  @return 信号
 */
- (RACSignal *)addressListWithID:(NSString *)identifier page:(NSInteger)page;

/**
 *  设为默认地址
 *
 *  @param identifier 用户ID
 *  @param addressID  地址ID
 *
 *  @return 信号
 */
- (RACSignal *)setDefaultAddressWithID:(NSString *)identifier addressID:(NSString *)addressID;

/**
 *  删除收货地址
 *
 *  @param identifier 用户ID
 *  @param addressID  地址ID
 *
 *  @return 信号
 */
- (RACSignal *)deleteAddressWithID:(NSString *)identifier addressID:(NSString *)addressID;


/**
 *  编辑收货地址
 *
 *  @param identifier     用户ID
 *  @param addressID      地址ID
 *  @param recipientsName 收件人
 *  @param province       省
 *  @param city           市
 *  @param district       区
 *  @param address        详细地址
 *  @param zipcode        邮编
 *  @param telephone      电话
 *  @param mobilePhone    手机
 *  @param email          邮箱
 *  @param signBuilding   标致建筑
 *  @param isDefault      是否设置默认
 *
 *  @return 信号
 */
- (RACSignal *)editAddressWithID:(NSString *)identifier addressID:(NSString *)addressID recipientsName:(NSString *)recipientsName province:(NSString *)province city:(NSString *)city district:(NSString *)district address:(NSString *)address zipcode:(NSString *)zipcode telephone:(NSString *)telephone mobilePhone:(NSString *)mobilePhone email:(NSString *)email signBuilding:(NSString *)signBuilding isDefault:(NSInteger)isDefault;

/**
 *  新增收货地址
 *
 *  @param identifier     用户ID
 *  @param recipientsName 收件人
 *  @param province       省
 *  @param city           市
 *  @param district       区
 *  @param address        详细地址
 *  @param zipcode        邮编
 *  @param telephone      电话
 *  @param mobilePhone    手机
 *  @param email          邮箱
 *  @param signBuilding   标志建筑
 *  @param isDefault      是否设为默认
 *
 *  @return 信号
 */
- (RACSignal *)addAddressWithID:(NSString *)identifier recipientsName:(NSString *)recipientsName provinceID:(NSString *)provinceid cityID:(NSString *)cityid districtID:(NSString *)districtid address:(NSString *)address zipcode:(NSString *)zipcode telephone:(NSString *)telephone mobilePhone:(NSString *)mobilePhone email:(NSString *)email signBuilding:(NSString *)signBuilding isDefault:(NSInteger)isDefault;

@end
