//
//  BaseViewController.h
//  DecorationChain
//
//  Created by huangxinping on 15/1/28.
//  Copyright (c) 2015年 ShareMerge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <A2StoryboardSegueContext/A2StoryboardSegueContext.h>
#import "BaseObject.h"
#import "BaseViewModel.h"
#import <XPKit/UIAlertView+XPKit.h>

@interface BaseViewController : UIViewController

@property (nonatomic, strong, setter = setupWithModel :, getter = model) BaseObject *model;

@property (nonatomic, strong) BaseViewModel *viewModel;

- (void)presentLogin;

- (UIViewController *)instantiateInitialViewControllerWithStoryboardName:(NSString *)storyboardName;

- (UIViewController *)instantiateViewControllerWithStoryboardName:(NSString *)storyboardName identifier:(NSString *)identifier;


@end


#define ALERT(text) [UIAlertView alertViewWithTitle: @"提示" message: text block: nil buttonTitle: @"确定"]
