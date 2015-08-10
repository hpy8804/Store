//
//  ProInfoTableViewCell.h
//  DecorationChain
//
//  Created by sven on 8/10/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProductInfoModelSV.h"

@interface ProInfoTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labelhuohao;

@property (weak, nonatomic) IBOutlet UILabel *labelPure;
@property (weak, nonatomic) IBOutlet UILabel *labelguige;
@property (weak, nonatomic) IBOutlet UILabel *labelchandi;
@property (weak, nonatomic) IBOutlet UILabel *labeljiage;
@property (weak, nonatomic) IBOutlet UILabel *labelkucun;
@property (weak, nonatomic) IBOutlet UILabel *labelshuliang;

- (void)updateCellWithInfo:(ProductInfoModelSV *)info;

@end
