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
    self.labelProductNO.text = carlist.good_number;
    self.labelPurity.text = carlist.pure;
    self.labelOrigin.text = carlist.pro_address;
    self.labelInventory.text = carlist.stock;
    self.labelSpecifications.text = carlist.norms;
    self.labelPrice.text = [NSString stringWithFormat:@"¥%@", carlist.good_price];
}

@end
