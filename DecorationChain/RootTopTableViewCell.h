//
//  RootTopTableViewCell.h
//  DecorationChain
//
//  Created by sven on 7/24/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTopTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UIButton *searchButton;
@property (weak, nonatomic) IBOutlet UIButton *moreButton;
@property (nonatomic, copy) void (^showMoreProduct)();

@end
