//
//  DecorationChainTests.m
//  DecorationChainTests
//
//  Created by huangxinping on 15/1/14.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import <OCHamcrest.h>

//#import "RootViewModel.h"

@interface DecorationChainTests : XCTestCase

//@property (nonatomic, strong) RootViewModel *viewModel;

@end

@implementation DecorationChainTests

- (void)setUp {
	[super setUp];

//	self.viewModel = [RootViewModel new];
}

- (void)tearDown {
	[super tearDown];
}

//- (void)testRacRemoteImage {
//	XCTestExpectation *expectation = [self expectationWithDescription:@"High Expectations"];
//
//	[self.viewModel.logoImage subscribeNext: ^(id x) {
//	    XCTAssertTrue(x != nil);
//	    [expectation fulfill];
//	}];
//
//	[self waitForExpectationsWithTimeout:5.0 handler: ^(NSError *error) {
//	    if (error) {
//	        NSLog(@"Timeout Error: %@", error);
//		}
//	}];
//}

- (void)testPerformanceExample {
	[self measureBlock: ^{
	}];
}

@end
