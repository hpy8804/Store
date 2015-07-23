//
//  BaseViewModel.m
//  DecorationChain
//
//  Created by huangxinping on 15/1/28.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseViewModel.h"
#import <AFNetworking/UIImageView+AFNetworking.h>
#import <XPToast/XPToast.h>
#import <XPKit/XPKit.h>

@implementation BaseViewModel

- (instancetype)init {
	if ((self = [super init])) {
		[self.didBecomeActiveSignal subscribeNext: ^(id x) {
		    XPLogVerbose(@"%@ Active!", [self className]);
		}];
		[self.didBecomeInactiveSignal subscribeNext: ^(id x) {
		    XPLogVerbose(@"%@ Inactive!", [self className]);
		}];
	}
	return self;
}

- (UIImage *)imageCacheWithPath:(NSString *)path {
	NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:path] cachePolicy:NSURLRequestReturnCacheDataElseLoad timeoutInterval:30.0f];
	UIImage *image = [[UIImageView sharedImageCache] cachedImageForRequest:urlRequest];
	if (image != nil) {
		return image;
	}
	return nil;
}

- (RACSignal *)rac_remoteImage:(NSString *)path {
	UIImage *cacheImage = [self imageCacheWithPath:path];
	if (cacheImage) {
		return [RACSignal createSignal: ^RACDisposable *(id < RACSubscriber > subscriber) {
		    [subscriber sendNext:cacheImage];
		    [subscriber sendCompleted];
		    return [RACDisposable disposableWithBlock: ^{
			}];
		}];
	}
	return [RACSignal createSignal: ^RACDisposable *(id < RACSubscriber > subscriber) {
	    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:path]];
	    AFHTTPRequestOperation *postOperation = [[AFHTTPRequestOperation alloc] initWithRequest:urlRequest];
	    postOperation.responseSerializer = [AFImageResponseSerializer serializer];
	    [postOperation setCompletionBlockWithSuccess: ^(AFHTTPRequestOperation *operation, id responseObject) {
	        UIImage *image = responseObject;
	        [[UIImageView sharedImageCache] cacheImage:image forRequest:urlRequest];
	        [subscriber sendNext:image];
	        [subscriber sendCompleted];
		} failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
	        [subscriber sendError:error];
		}];
	    [postOperation start];

	    return [RACDisposable disposableWithBlock: ^{
		}];
	}];
}

- (id)analysisRequest:(id)value {
	if (![value isKindOfClass:[NSDictionary class]]) {
		value = [(RACTuple *)value first];
	}
//	NSString *escapeValue =  [[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding];
//	value = [escapeValue stringToObject];
	NSAssert([value isKindOfClass:[NSDictionary class]], @"JSON结果集必须为NSDictionary");
	if (![value[@"status"] boolValue]) {
		[XPToast showWithText:value[@"msg"]];
		return @[];
	}
	return value[@"data"];
}

@end


@implementation BaseViewModel (AFNetWorking)

- (AFHTTPRequestOperationManager *)manager {
	AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
//	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", @"text/plain", nil];
//	manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//	manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//	manager.responseSerializer.stringEncoding = NSUTF8StringEncoding;

//	manager.responseSerializer = [AFJSONResponseSerializer serializerWithReadingOptions:NSJSONReadingAllowFragments];
	manager.responseSerializer.acceptableStatusCodes = nil;
	return manager;
}

- (RACSignal *)rac_GET:(NSString *)path parameters:(id)parameters {
	AFHTTPRequestOperationManager *manager = [self manager];
	return [manager rac_GET:path parameters:parameters];
}

- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters {
	AFHTTPRequestOperationManager *manager = [self manager];
	return [manager rac_POST:path parameters:parameters];
}

- (RACSignal *)rac_PUT:(NSString *)path parameters:(id)parameters {
	AFHTTPRequestOperationManager *manager = [self manager];
	return [manager rac_PUT:path parameters:parameters];
}

- (RACSignal *)rac_DELETE:(NSString *)path parameters:(id)parameters {
	AFHTTPRequestOperationManager *manager = [self manager];
	return [manager rac_DELETE:path parameters:parameters];
}

- (RACSignal *)rac_PATCH:(NSString *)path parameters:(id)parameters {
	AFHTTPRequestOperationManager *manager = [self manager];
	return [manager rac_PATCH:path parameters:parameters];
}

@end


@implementation BaseViewModel (AFNetWorking_Retry)

- (AFHTTPSessionManager *)sessionManager {
	AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//	manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html", nil];
//	manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//	manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//	manager.responseSerializer.stringEncoding = NSUTF8StringEncoding;
//	manager.responseSerializer.acceptableStatusCodes = nil;
	return manager;
}

#pragma mark - GET

- (RACSignal *)rac_GET:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_GET:path parameters:parameters retries:retries];
}

- (RACSignal *)rac_GET:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_GET:path parameters:parameters retries:retries interval:interval];
}

- (RACSignal *)rac_GET:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval test:(RACURLSessionRetryTestBlock)testBlock {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_GET:path parameters:parameters retries:retries interval:interval test:testBlock];
}

#pragma mark - HEAD

- (RACSignal *)rac_HEAD:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_HEAD:path parameters:parameters retries:retries];
}

- (RACSignal *)rac_HEAD:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_HEAD:path parameters:parameters retries:retries interval:interval];
}

- (RACSignal *)rac_HEAD:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval test:(RACURLSessionRetryTestBlock)testBlock {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_HEAD:path parameters:parameters retries:retries interval:interval test:testBlock];
}

#pragma mark - POST

- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_POST:path parameters:parameters retries:retries];
}

- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_POST:path parameters:parameters retries:retries interval:interval];
}

- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval test:(RACURLSessionRetryTestBlock)testBlock {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_POST:path parameters:parameters retries:retries interval:interval test:testBlock];
}

- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block retries:(NSInteger)retries {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_POST:path parameters:parameters constructingBodyWithBlock:block retries:retries];
}

- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block retries:(NSInteger)retries interval:(NSTimeInterval)interval {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_POST:path parameters:parameters constructingBodyWithBlock:block retries:retries interval:interval];
}

- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters constructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block retries:(NSInteger)retries interval:(NSTimeInterval)interval test:(RACURLSessionRetryTestBlock)testBlock {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_POST:path parameters:parameters constructingBodyWithBlock:block retries:retries interval:interval test:testBlock];
}

#pragma mark - PUT

- (RACSignal *)rac_PUT:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_PUT:path parameters:parameters retries:retries];
}

- (RACSignal *)rac_PUT:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_PUT:path parameters:parameters retries:retries interval:interval];
}

- (RACSignal *)rac_PUT:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval test:(RACURLSessionRetryTestBlock)testBlock {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_PUT:path parameters:parameters retries:retries interval:interval test:testBlock];
}

#pragma mark - PATCH

- (RACSignal *)rac_PATCH:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_PATCH:path parameters:parameters retries:retries];
}

- (RACSignal *)rac_PATCH:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_PATCH:path parameters:parameters retries:retries interval:interval];
}

- (RACSignal *)rac_PATCH:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval test:(RACURLSessionRetryTestBlock)testBlock {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_PATCH:path parameters:parameters retries:retries interval:interval test:testBlock];
}

#pragma mark - DELETE

- (RACSignal *)rac_DELETE:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_DELETE:path parameters:parameters retries:retries];
}

- (RACSignal *)rac_DELETE:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_DELETE:path parameters:parameters retries:retries interval:interval];
}

- (RACSignal *)rac_DELETE:(NSString *)path parameters:(id)parameters retries:(NSInteger)retries interval:(NSTimeInterval)interval test:(RACURLSessionRetryTestBlock)testBlock {
	AFHTTPSessionManager *sessionManager = [self sessionManager];
	return [sessionManager rac_DELETE:path parameters:parameters retries:retries interval:interval test:testBlock];
}

@end
