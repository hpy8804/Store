//
//  MyAddressViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/20.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "MyAddressViewModel.h"
#import "AddressModel.h"
#import "NSDictionary+fill_deviceinfo.h"

@implementation MyAddressViewModel

- (RACSignal *)addressListWithID:(NSString *)identifier page:(NSInteger)page {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/account_address"
	            parameters  :[@{
	                              @"account_id":identifier,
	                              @"page":@(page)
							  } fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (NSArray *value) {
	    return [[[value rac_sequence] map: ^id (id value) {
	        return [[AddressModel alloc] initWithDictionary:value error:nil];
		}] array];
	}];
}

- (RACSignal *)setDefaultAddressWithID:(NSString *)identifier addressID:(NSString *)addressID {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/set_default_address"
	            parameters  :[@{
	                              @"account_id":identifier,
	                              @"address_id":addressID
							  } fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return value;
	}];
}

- (RACSignal *)deleteAddressWithID:(NSString *)identifier addressID:(NSString *)addressID {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/delete_address"
	            parameters  :[@{
	                              @"account_id":identifier,
	                              @"id":addressID
							  } fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return value;
	}];
}

- (RACSignal *)editAddressWithID:(NSString *)identifier addressID:(NSString *)addressID recipientsName:(NSString *)recipientsName province:(NSString *)province city:(NSString *)city district:(NSString *)district address:(NSString *)address zipcode:(NSString *)zipcode telephone:(NSString *)telephone mobilePhone:(NSString *)mobilePhone email:(NSString *)email signBuilding:(NSString *)signBuilding isDefault:(NSInteger)isDefault {
	NSMutableDictionary *parameters = [@{
	                                       @"account_id":identifier,
	                                       @"id":addressID,
	                                       @"recipients_name":recipientsName,
	                                       @"address":address,
	                                       @"provinceid":province,
	                                       @"cityid":city,
	                                       @"telephone":telephone,
	                                       @"is_default":@(isDefault)
									   } mutableCopy];
	if (district && ![district isEqualToString:@""]) {
		[parameters setObject:district forKey:@"districtid"];
	}
	if (zipcode && ![zipcode isEqualToString:@""]) {
		[parameters setObject:zipcode forKey:@"zipcode"];
	}
	if (mobilePhone && ![mobilePhone isEqualToString:@""]) {
		[parameters setObject:mobilePhone forKey:@"mob_phone"];
	}
	if (email && ![email isEqualToString:@""]) {
		[parameters setObject:email forKey:@"email"];
	}
	if (signBuilding && ![signBuilding isEqualToString:@""]) {
		[parameters setObject:signBuilding forKey:@"sign_building"];
	}
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/edit_address"
	            parameters  :[parameters fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return value;
	}];
}

- (RACSignal *)addAddressWithID:(NSString *)identifier recipientsName:(NSString *)recipientsName provinceID:(NSString *)provinceid cityID:(NSString *)cityid districtID:(NSString *)districtid address:(NSString *)address zipcode:(NSString *)zipcode telephone:(NSString *)telephone mobilePhone:(NSString *)mobilePhone email:(NSString *)email signBuilding:(NSString *)signBuilding isDefault:(NSInteger)isDefault {
	NSMutableDictionary *parameters = [@{
	                                       @"account_id":identifier,
	                                       @"recipients_name":recipientsName,
	                                       @"address":address,
	                                       @"provinceid":provinceid,
	                                       @"cityid":cityid,
	                                       @"districtid":districtid,
	                                       @"telephone":telephone,
	                                       @"is_default":@(isDefault)
									   } mutableCopy];
	if (zipcode && ![zipcode isEqualToString:@""]) {
		[parameters setObject:zipcode forKey:@"zipcode"];
	}
	if (mobilePhone && ![mobilePhone isEqualToString:@""]) {
		[parameters setObject:mobilePhone forKey:@"mob_phone"];
	}
	if (email && ![email isEqualToString:@""]) {
		[parameters setObject:email forKey:@"email"];
	}
	if (signBuilding && ![signBuilding isEqualToString:@""]) {
		[parameters setObject:signBuilding forKey:@"sign_building"];
	}
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/add_address"
	            parameters  :[parameters fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return value;
	}];
}

@end
