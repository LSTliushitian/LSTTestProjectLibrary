//
//  BasicViewController.m
//  TravelIndustry
//
//  Created by 刘士天 on 2018/5/15.
//  Copyright © 2018年 刘士天. All rights reserved.
//

#import "BasicViewController.h"

@interface BasicViewController ()

@end

@implementation BasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.hidden = YES;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    /**
     1. 背景视图
     */
    [self.view addSubview:({
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, SafeAreaTopHeight)];
        _backView.backgroundColor = [UIColor orangeColor];
        _backView.userInteractionEnabled = YES;
        
        _backView;
    })];
    
    /**
     2. 标题标签
     */
    [self.view addSubview:({
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, SafeAreaTopHeight-44, SCREENWIDTH-80, 44)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.font = [UIFont systemFontOfSize:32];
        
        _titleLabel;
    })];
    
    /**
     3. 返回按钮
     */
    [self.view addSubview:({
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _backButton.frame = CGRectMake(0, SafeAreaTopHeight-44, 40, 44);
        _backButton.titleLabel.font = [UIFont systemFontOfSize:32];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backButton setTitle:@"<" forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        _backButton;
    })];
    
    /**
     4. 右侧按钮
     */
    [self.view addSubview:({
        _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _rightButton.frame = CGRectMake(SCREENWIDTH-40, SafeAreaTopHeight-44, 40, 44);
        _rightButton.titleLabel.font = [UIFont systemFontOfSize:32];
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_rightButton setTitle:@"+" forState:UIControlStateNormal];
        
        _rightButton.hidden = YES;
        _rightButton;
    })];
    
//    self.navigationController.interactivePopGestureRecognizer.enabled = YES;//侧滑
    
}

#pragma mark - 按钮点击事件
- (void) backButtonClick:(UIButton *) sender {//返回按钮点击事件
    [self.navigationController popViewControllerAnimated:YES];
}

@end
