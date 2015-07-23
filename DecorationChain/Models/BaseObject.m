//
//  BaseObject.m
//  DecorationChain
//
//  Created by huangxinping on 15/1/31.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseObject.h"

@implementation BaseObject

- (NSString *)description {
	return [self autoDescription];
}

- (instancetype)init {
	if ((self = [super init])) {
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[self autoEncodeWithCoder:coder];
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [super init]) {
		[self autoDecode:aDecoder];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	BaseObject *temp = [[[self class] allocWithZone:zone] init];
	return temp;
}

@end

static NSMutableDictionary *_singletons;
@implementation BaseObject (Singleton)

+ (instancetype)singleton {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		_singletons = [NSMutableDictionary dictionary];
	});

	id instance = nil;
	@synchronized(self)
	{
		NSString *klass = NSStringFromClass(self);
		instance = _singletons[klass];
		if (!instance) {
			instance = [self new];
			_singletons[klass] = instance;
		}
	}
	return instance;
}

@end
