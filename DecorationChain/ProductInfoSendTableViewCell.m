//
//  ProductInfoSendTableViewCell.m
//  DecorationChain
//
//  Created by huangxinping on 15/3/19.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "ProductInfoSendTableViewCell.h"

#import <CLLocationManager-blocks/CLLocationManager+blocks.h>
#import <LMGeocoder/LMGeocoder.h>
#import <libextobjc/EXTScope.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ProductInfoSendTableViewCell () <CLLocationManagerDelegate>
{
	CLLocationManager *locationManager;
}
@end

@implementation ProductInfoSendTableViewCell

- (void)awakeFromNib {
//	CLLocationManager *manager = [CLLocationManager updateManagerWithAccuracy:50.0 locationAge:15.0 authorizationDesciption:CLLocationUpdateAuthorizationDescriptionAlways];
//	[manager startUpdatingLocationWithUpdateBlock: ^(CLLocationManager *manager, CLLocation *location, NSError *error, BOOL *stopUpdating) {
//	    NSLog(@"Our new location: %@", location);
//	    [[LMGeocoder sharedInstance] reverseGeocodeCoordinate:location.coordinate
//	                                                  service:kLMGeocoderAppleService
//	                                        completionHandler: ^(LMAddress *address, NSError *error) {
//	        if (address && !error) {
//	            NSLog(@"Address: %@", address.formattedAddress);
//			}
//	        else {
//	            NSLog(@"Error: %@", error.description);
//			}
//		}];
//	    *stopUpdating = YES;
//	}];
	@weakify(self);
	[[self.sendAddressButton rac_signalForControlEvents:UIControlEventTouchUpInside]
	 subscribeNext: ^(id x) {
	    @strongify(self);
	    [self.sendAddressButton setTitle:@"正在定位中..." forState:UIControlStateNormal];
	    [self startLocation];
	}];
	[self.sendAddressButton setTitle:@"正在定位中..." forState:UIControlStateNormal];
	[self.sendAddressButton sendActionsForControlEvents:UIControlEventTouchUpInside];
}

- (void)startLocation {
	locationManager = [[CLLocationManager alloc] init];
	if ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]) {
		[locationManager requestAlwaysAuthorization]; // 永久授权
		[locationManager requestWhenInUseAuthorization]; //使用中授权
	}
	locationManager.delegate = self;
	[locationManager startUpdatingLocation];
}

- (void)locationManager:(CLLocationManager *)manager
    didUpdateToLocation:(CLLocation *)newLocation
           fromLocation:(CLLocation *)oldLocation {
//	NSLog(@"Our new location: %@", newLocation);
	@weakify(self);
	[[LMGeocoder sharedInstance] reverseGeocodeCoordinate:newLocation.coordinate
	                                              service:kLMGeocoderAppleService
	                                    completionHandler: ^(LMAddress *address, NSError *error) {
	    if (address && !error) {
	        @strongify(self);
	        NSString *buffer = [NSString stringWithFormat:@"%@ > %@ > %@", address.administrativeArea, address.locality, address.subLocality];
	        [self.sendAddressButton setTitle:buffer forState:UIControlStateNormal];
		}
	    else {
//	        NSLog(@"Error: %@", error.description);
		}
	}];
}

@end
