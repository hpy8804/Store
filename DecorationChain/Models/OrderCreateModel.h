//
//  OrderCreateModel.h
//  DecorationChain
//
//  Created by huangxinping on 4/8/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "JSONModel.h"

@protocol OrderCreateContentModel <NSObject>
@end
@interface OrderCreateContentModel : JSONModel

@property NSString <Optional> *brandcateId;
@property NSString <Optional> *categoriesId;
@property NSString <Optional> *description;
@property NSString <Optional> *excerpt;
@property NSString <Optional> *id;
@property NSString <Optional> *images;
@property NSString <Optional> *name;
@property NSString <Optional> *number;
@property NSString <Optional> *options;
@property NSString <Optional> *postOptions;
@property NSString <Optional> *price;
@property NSString <Optional> *quantity;
@property NSString <Optional> *routeId;
@property NSString <Optional> *saleprice;
@property NSString <Optional> *sku;
@property NSString <Optional> *slug;

@end

@interface OrderCreateModel : JSONModel

@property NSString <Optional> *accountId;
@property NSArray <OrderCreateContentModel, Optional> *contents;
@property NSString <Optional> *email;
@property NSString <Optional> *fapiaoId;
@property NSString <Optional> *firstname;
@property NSString <Optional> *id;
@property NSString <Optional> *items;
@property NSString <Optional> *lastname;
@property NSString <Optional> *name;
@property NSString <Optional> *orderNumber;
@property NSString <Optional> *orderStatus;
@property NSString <Optional> *orderedOn;
@property NSString <Optional> *payStatus;
@property NSString <Optional> *phone;
@property NSString <Optional> *shipAddress;
@property NSString <Optional> *shipCity;
@property NSString <Optional> *shipCompany;
@property NSString <Optional> *shipCountry;
@property NSString <Optional> *shipDistrict;
@property NSString <Optional> *shipEmail;
@property NSString <Optional> *shipFirstname;
@property NSString <Optional> *shipLastname;
@property NSString <Optional> *shipPhone;
@property NSString <Optional> *shipProvince;
@property NSString <Optional> *shipZip;
@property NSString <Optional> *shipment;
@property NSString <Optional> *shipping;
@property NSString <Optional> *status;
@property NSString <Optional> *subtotal;
@property NSString <Optional> *total;
@property NSString <Optional> *weightTotal;

@end
