//
//  BasicViewController.h
//  TravelIndustry
//
//  Created by 刘士天 on 2018/5/15.
//  Copyright © 2018年 刘士天. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BasicViewController : UIViewController

/**
 1. 背景视图
 */
@property (strong, nonatomic) UIView * backView;

/**
 2. 标题标签
 */
@property (strong, nonatomic) UILabel * titleLabel;

/**
 3. 返回按钮
 */
@property (strong, nonatomic) UIButton * backButton;

/**
 4. 右侧按钮
 */
@property (strong, nonatomic) UIButton *rightButton;

- (void) backButtonClick:(UIButton *) sender;//返回按钮点击事件

@end
