//
//  ProductInfoMoreTableViewCell.h
//  DecorationChain
//
//  Created by huangxinping on 4/6/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductInfoMoreTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *infoLabel;
@property (weak, nonatomic) IBOutlet UIWebView *infoWebView;

@property (nonatomic, assign) CGFloat height;

- (void)updateUIWithContent:(NSString *)htmlString;

- (void)expandUI;

@end
