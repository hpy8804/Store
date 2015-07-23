//
//  ReportViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/5/28.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ReportViewModel.h"
#import "NSDictionary+fill_deviceinfo.h"
#import "ReportCategoriesModel.h"
#import "ReportStoreModel.h"
#import "ReportHistoryModel.h"

@implementation ReportViewModel

- (RACSignal *)reportHistoryListWithID:(NSString *)identifier type:(NSString *)type page:(NSInteger)page {
	return [[[[self rac_GET:@"http://27.54.252.32/zjb/api/enable_orders"
	             parameters  :[@{
	                               @"account_id":identifier,
	                               @"type":type,
	                               @"page":@(page)
							   } fillDeviceInfo]]
	          map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (NSArray *value) {
	    return [[[value rac_sequence] map: ^id (id value) {
	        return [[ReportHistoryModel alloc] initWithDictionary:value error:nil];
		}] array];
	}] map: ^id (NSArray *value) {
	    return [value sortedArrayUsingComparator: ^NSComparisonResult (ReportHistoryModel *obj1, ReportHistoryModel *obj2) {
	        if (obj1.postTime.integerValue < obj2.postTime.integerValue) {
	            return NSOrderedAscending;
			}
	        else {
	            return NSOrderedDescending;
			}
		}];
	}];
}

- (RACSignal *)reportDetailWithID:(NSString *)identifier analysisID:(NSString *)analysisID {
	return [[[[self rac_GET:@"http://27.54.252.32/zjb/api/baodan_order_detail"
	             parameters  :[@{
	                               @"account_id":identifier,
	                               @"analysis_id":analysisID
							   } fillDeviceInfo]]
	          map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (NSDictionary *value) {
	    return value[@"detail"];
	}] map: ^id (NSArray *value) {
	    return [[[value rac_sequence] map: ^id (id value) {
	        return [[ReportStoreModel alloc] initWithDictionary:value error:nil];
		}] array];
	}];
}

- (RACSignal *)categories {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/all_categories" parameters:[@{} fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (NSArray *value) {
	    return [[[value rac_sequence] map: ^id (id value) {
	        return [[ReportCategoriesModel alloc] initWithDictionary:value error:nil];
		}] array];
	}];
}

- (RACSignal *)reportProductsWithID:(NSString *)identifier categoryID:(NSString *)categoryID page:(NSInteger)page {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/report_produts"
	            parameters  :[@{
	                              @"account_id":identifier ? identifier : @"0",
	                              @"categories_id":categoryID,
	                              @"page":@(page)
							  } fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}] map: ^id (NSArray *value) {
	    return [[[value rac_sequence] map: ^id (id value) {
	        return [[ReportStoreModel alloc] initWithDictionary:value error:nil];
		}] array];
	}];
}

- (RACSignal *)createReportWithID:(NSString *)identifier addressID:(NSString *)addressID type:(NSString *)type reports:(NSArray *)reports {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:identifier forKey:@"account_id"];
	[parameters setObject:addressID forKey:@"address_id"];
	[parameters setObject:type forKey:@"type"];
	for (NSInteger i = 0; i < reports.count; i++) {
		NSDictionary *item = reports[i];
		NSString *key1 = [NSString stringWithFormat:@"reports[%ld][id]", (long)i];
		[parameters setObject:item[@"id"] forKey:key1];
		NSString *key2 = [NSString stringWithFormat:@"reports[%ld][nums]", (long)i];
		[parameters setObject:item[@"num"] forKey:key2];
	}

	return [[[self rac_POST:@"http://27.54.252.32/zjb/api/report_sub"
	             parameters :[parameters fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}]
	        map: ^id (id value) {
	    return value;
	}];
}

- (RACSignal *)addReportCartWithID:(NSString *)identifier addressID:(NSString *)addressID type:(NSString *)type reports:(NSArray *)reports {
	NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
	[parameters setObject:identifier forKey:@"account_id"];
	[parameters setObject:addressID forKey:@"address_id"];
	[parameters setObject:type forKey:@"type"];
	for (NSInteger i = 0; i < reports.count; i++) {
		NSDictionary *item = reports[i];
		NSString *key1 = [NSString stringWithFormat:@"reports[%ld][id]", (long)i];
		[parameters setObject:item[@"id"] forKey:key1];
		NSString *key2 = [NSString stringWithFormat:@"reports[%ld][nums]", (long)i];
		[parameters setObject:item[@"num"] forKey:key2];
	}
	return [[[self rac_POST:@"http://27.54.252.32/zjb/api/add_report_cart"
	             parameters :[parameters fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}]
	        map: ^id (id value) {
	    return value;
	}];
}

- (RACSignal *)myReportsWithID:(NSString *)identifier page:(NSInteger)page {
	return [[[self rac_GET:@"http://27.54.252.32/zjb/api/initial_report_cart"
	            parameters  :[@{
	                              @"account_id":identifier,
	                              @"page":@(page)
							  } fillDeviceInfo]]
	         map: ^id (id value) {
	    return [self analysisRequest:value];
	}]
	        map: ^id (id value) {
	    return [[[value rac_sequence] map: ^id (id value) {
	        return [[ReportStoreModel alloc] initWithDictionary:value error:nil];
		}] array];
	}];
}

@end
