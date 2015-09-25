//
//  GoodsCarTableViewCell.m
//  DecorationChain
//
//  Created by sven on 8/4/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import "GoodsCarTableViewCell.h"

@implementation GoodsCarTableViewCell

- (void)awakeFromNib {
    @weakify(self);
    self.number = 0;
    
    [[self.reduceButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext: ^(id x) {
         @strongify(self);
         self.number--;
         self.number = self.number <= 0 ? 1 : self.number;
         self.labelCount.text = [NSString stringWithFormat:@"%ld件", (long)self.number];
     }];
    [[self.increaseButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext: ^(id x) {
         @strongify(self);
         self.number++;
         self.number = self.number >= 99 ? 99 : self.number;
         self.labelCount.text = [NSString stringWithFormat:@"%ld件", (long)self.number];
     }];
    
    self.reduceButton.hidden = YES;
    self.increaseButton.hidden = YES;
}

- (void)updateUIWithModel:(subCarList *)carlist
{
    self.labelProductNO.text = (carlist.good_number != (NSString *)[NSNull null])?carlist.good_number:@"";
    self.labelPurity.text = (carlist.pure != (NSString *)[NSNull null])?carlist.pure:@"";
    self.labelOrigin.text = (carlist.pro_address != (NSString *)[NSNull null])?carlist.pro_address:@"";
    self.labelInventory.text = (carlist.stock != (NSString *)[NSNull null])?carlist.stock:@"";
    self.labelSpecifications.text = (carlist.norms != (NSString *)[NSNull null])?carlist.norms:@"";
    self.labelPrice.text = [NSString stringWithFormat:@"¥%@", ((carlist.good_price != (NSString *)[NSNull null])?carlist.good_price:@"")];
    self.labelCount.text = [NSString stringWithFormat:@"%@件", ((carlist.quantity != (NSString *)[NSNull null])?carlist.quantity:@"")];
}

@end
