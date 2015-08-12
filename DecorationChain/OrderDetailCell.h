//
//  OrderDetailCell.h
//  DecorationChain
//
//  Created by sven on 8/12/15.
//  Copyright (c) 2015 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface OrderDetailModel: NSObject
@property (strong, nonatomic) NSString *mingcheng;
@property (strong, nonatomic) NSString *huohao;
@property (strong, nonatomic) NSString *cundu;
@property (strong, nonatomic) NSString *guige;
@property (strong, nonatomic) NSString *chandi;
@property (strong, nonatomic) NSString *jiage;
@property (strong, nonatomic) NSString *kucun;
@property (strong, nonatomic) NSString *shuliang;
@end

@interface OrderDetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labelhuohao;
@property (weak, nonatomic) IBOutlet UILabel *mingcheng;
@property (weak, nonatomic) IBOutlet UILabel *labelcundu;
@property (weak, nonatomic) IBOutlet UILabel *labelguige;
@property (weak, nonatomic) IBOutlet UILabel *labelchandi;
@property (weak, nonatomic) IBOutlet UILabel *labeljiage;
@property (weak, nonatomic) IBOutlet UILabel *labelkucun;
@property (weak, nonatomic) IBOutlet UILabel *labelshuliang;

- (void)updateWithModel:(OrderDetailModel *)model;

@end
