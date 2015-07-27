//
//  RootTopTableViewCell.h
//  DecorationChain
//
//  Created by sven on 7/24/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RootTopTableViewCell : UITableViewCell<UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UIButton *categoryButton;
@property (weak, nonatomic) IBOutlet UITextField *keyWordTextField;
@property (nonatomic, copy) void (^showMoreProduct)();
@property (nonatomic, copy) void (^showSearchResult)(NSString *category, NSString *keyWord);

@end
