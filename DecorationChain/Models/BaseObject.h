//
//  BaseObject.h
//  DecorationChain
//
//  Created by huangxinping on 15/1/31.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NSObject+AutoDescription/NSObject+AutoDescription.h>
#import <NSObject-Tap/NSObject+Tap.h>
#import <NSObject-NSCoding/NSObject+NSCoding.h>
#import <JSONModel/JSONModel.h>
#import <RXCollections/RXCollection.h>

@interface BaseObject : JSONModel <NSCoding, RXCollection, NSCopying>

@property (nonatomic, strong) NSString <Optional> *identifier;
@property (nonatomic, strong) NSString <Optional> *baseTransfer;

@end

@interface BaseObject (Singleton)

+ (instancetype)singleton;

@end
