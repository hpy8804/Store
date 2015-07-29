//
//  AreaPickViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 4/7/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "AreaPickViewModel.h"

#import "NSDictionary+fill_deviceinfo.h"

#import "AddressProvinceModel.h"
#import "AddressCityModel.h"
#import "AddressDistrictModel.h"

@implementation AreaPickViewModel


- (RACSignal *)provinces {
	return [[[self rac_GET:@"http://122.114.61.234/app/api/provices"
	            parameters  :[@{} fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (NSArray *value) {
	    return [[[value rac_sequence] map: ^id (id value) {
	        return [[AddressProvinceModel alloc] initWithDictionary:value error:nil];
		}] array];
	}];
}

- (RACSignal *)citysWithProvinceID:(NSString *)provinceID {
	return [[[self rac_GET:@"http://122.114.61.234/app/api/city"
	            parameters  :[@{
	                              @"province_id":provinceID
							  } fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return [[[value rac_sequence] map: ^id (id value) {
	        return [[AddressCityModel alloc] initWithDictionary:value error:nil];
		}] array];
	}];
}

- (RACSignal *)districtsWithCityID:(NSString *)cityID {
	return [[[self rac_GET:@"http://122.114.61.234/app/api/district"
	            parameters  :[@{
	                              @"cityid":cityID
							  } fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (id value) {
	    return [[[value rac_sequence] map: ^id (id value) {
	        return [[AddressDistrictModel alloc] initWithDictionary:value error:nil];
		}] array];
	}];
}

@end
