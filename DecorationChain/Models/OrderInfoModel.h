//
//  OrderInfoModel.h
//  DecorationChain
//
//  Created by huangxinping on 15/3/21.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import "BaseObject.h"

@protocol OrderInfoContentModel <NSObject>
@end

@interface OrderInfoContentModel : BaseObject

@property NSString <Optional> *brandcateId;
@property NSString *categoriesId;
@property NSString *self_description;
@property NSString *excerpt;
@property NSString *id;
@property NSString *images;
@property NSString *name;
@property NSString *number;
@property NSString <Optional> *options;
@property NSString *orderId;
@property NSString <Optional> *postOptions;
@property NSString *productId;
@property NSString *quantity;
@property NSString <Optional> *routeId;
@property NSString *saleprice;
@property NSString <Optional> *sku;
@property NSString <Optional> *slug;

@end

@interface OrderInfoModel : BaseObject

@property NSString <Optional> *accountId;
@property NSString <Optional> *billAddress;
@property NSString <Optional> *billCity;
@property NSString <Optional> *billCompany;
@property NSString <Optional> *billCountry;
@property NSString <Optional> *billCountryCode;
@property NSString <Optional> *billCountryId;
@property NSString <Optional> *billDistrict;
@property NSString <Optional> *billEmail;
@property NSString <Optional> *billFirstname;
@property NSString <Optional> *billLastname;
@property NSString <Optional> *billPhone;
@property NSString <Optional> *billProvince;
@property NSString <Optional> *billZip;
@property NSString <Optional> *billZoneId;
@property NSString *contentItems;
@property NSArray <OrderInfoContentModel> *contents;
@property NSString <Optional> *couponDiscount;
@property NSString *email;
@property NSString *fapiaoId;
@property NSString <Optional> *firstname;
@property NSString <Optional> *giftCardDiscount;
@property NSString *id;
@property NSString *isAble;
@property NSString *isPay;
@property NSString *items;
@property NSString <Optional> *lastname;
@property NSString *name;
@property NSString <Optional> *notes;
@property NSString *orderNumber;
@property NSString *orderStatus;
@property NSString <Optional> *orderType;
@property NSString *orderedOn;
@property NSString *payStatus;
@property NSString <Optional> *paymentInfo;
@property NSString <Optional> *phone;
@property NSString <Optional> *referral;
@property NSString <Optional> *shipAddress;
@property NSString *shipCity;
@property NSString <Optional> *shipCompany;
@property NSString *shipCountry;
@property NSString <Optional> *shipCountryCode;
@property NSString <Optional> *shipCountryId;
@property NSString *shipDistrict;
@property NSString <Optional> *shipEmail;
@property NSString <Optional> *shipFirstname;
@property NSString <Optional> *shipLastname;
@property NSString *shipPhone;
@property NSString *shipProvince;
@property NSString <Optional> *shipZip;
@property NSString <Optional> *shipZoneId;
@property NSString *shipment;
@property NSString <Optional> *shippedOn;
@property NSString <Optional> *shipping;
@property NSString <Optional> *shippingMethod;
@property NSString <Optional> *shippingNotes;
@property NSString *status;
@property NSString *subtotal;
@property NSString <Optional> *tax;
@property NSString *total;
@property NSString <Optional> *weightTotal;

@end
