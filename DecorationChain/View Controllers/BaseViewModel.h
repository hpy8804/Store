//
//  BaseViewModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/1/28.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveViewModel/ReactiveViewModel.h>
#import <AFNetworking-RACExtensions/RACAFNetworking.h>
#import <AFNetworking-RACRetryExtensions/AFHTTPSessionManager+RACRetrySupport.h>

@interface BaseViewModel : RVMViewModel

- (RACSignal *)rac_remoteImage:(NSString *)path;

- (id)analysisRequest:(id)value;

@end


@interface BaseViewModel (AFNetWorking)

- (RACSignal *)rac_GET:(NSString *)path parameters:(id)parameters;

- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters;

- (RACSignal *)rac_PUT:(NSString *)path parameters:(id)parameters;

- (RACSignal *)rac_DELETE:(NSString *)path parameters:(id)parameters;

- (RACSignal *)rac_PATCH:(NSString *)path parameters:(id)parameters;

@end

@interface BaseViewModel (AFNetWorking_Retry)

- (RACSignal *)rac_GET:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries;
- (RACSignal *)rac_GET:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval;
- (RACSignal *)rac_GET:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval test:(RACURLSessionRetryTestBlock)testBlock;

- (RACSignal *)rac_HEAD:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries;
- (RACSignal *)rac_HEAD:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval;
- (RACSignal *)rac_HEAD:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval test:(RACURLSessionRetryTestBlock)testBlock;

- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries;
- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval;
- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval test:(RACURLSessionRetryTestBlock)testBlock;

- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block retries:(NSInteger)retries;
- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block retries:(NSInteger)retries interval:(NSTimeInterval)interval;
- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block retries:(NSInteger)retries interval:(NSTimeInterval)interval test:(RACURLSessionRetryTestBlock)testBlock;

- (RACSignal *)rac_PUT:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries;
- (RACSignal *)rac_PUT:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval;
- (RACSignal *)rac_PUT:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval test:(RACURLSessionRetryTestBlock)testBlock;

- (RACSignal *)rac_PATCH:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries;
- (RACSignal *)rac_PATCH:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval;
- (RACSignal *)rac_PATCH:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval test:(RACURLSessionRetryTestBlock)testBlock;

- (RACSignal *)rac_DELETE:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries;
- (RACSignal *)rac_DELETE:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval;
- (RACSignal *)rac_DELETE:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval test:(RACURLSessionRetryTestBlock)testBlock;

@end
