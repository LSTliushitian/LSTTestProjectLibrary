//
//  ZJScrollLabelTool.m
//  车管家
//
//  Created by 张晶 on 2018/3/30.
//  Copyright © 2018年 zj. All rights reserved.
//

#import "ZJScrollLabelTool.h"

#define WIDTH ([UIScreen mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ZJScrollLabelTool () <UIScrollViewDelegate>
{
    //点击回调
    void(^_clickBlock)(NSInteger clickIndex);
    //计时器
    NSTimer *_timer;
    //当前横向偏移量
    CGFloat _xOffset;
    
}
//滚动视图
@property (nonatomic) UIScrollView *scrollView;
// 宽
@property (nonatomic, assign) CGFloat width;
// 高
@property (nonatomic, assign) CGFloat height;

@end

@implementation ZJScrollLabelTool

- (void)createScrollImgWithView:(UIView *)view backgroundColor:(UIColor *)backgroundColor titleArray:(NSArray *)titleArray width:(CGFloat)width height:(CGFloat)height ClickBlock:(void (^)(NSInteger))clickBlock
{
    for (UIView *vie in self.subviews) {
        [vie removeFromSuperview];
    }
    
    _width = width;
    _height = height;
    [_timer invalidate];
    
    //轮播图滚动区域
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    _scrollView.backgroundColor = backgroundColor;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.contentSize = CGSizeMake(width, height*(titleArray.count+2));
    [view addSubview:_scrollView];
    
    for (int i = 0; i < titleArray.count+2; i++) {
        //滚动按钮
        UIButton *scrollBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        scrollBtn.frame = CGRectMake(20*pix, height*i, width-20*pix, height);
        scrollBtn.backgroundColor = backgroundColor;
        
        ZJLabel *label = [ZJLabel labelWithFrame:CGRectMake(0, 0, width-20*pix, height) Text:@"" TextColor:[UIColor grayColor] Font:MiddleFont NumberOfLines:1 TextAlignment:NSTextAlignmentLeft BackgroundColor:[UIColor clearColor]];
        [scrollBtn addSubview:label];
        
        //放置本地文字
        if (!i) {
            scrollBtn.tag = 1000+titleArray.count-1;
            label.text = titleArray.lastObject;
//            [scrollBtn setTitle:titleArray.lastObject forState:UIControlStateNormal];
        } else if (i == titleArray.count+1) {
            scrollBtn.tag = 1000;
            label.text = titleArray.firstObject;
//            [scrollBtn setTitle:titleArray.firstObject forState:UIControlStateNormal];
        } else {
            scrollBtn.tag = 1000 + i - 1;
            label.text = titleArray[i-1];
//            [scrollBtn setTitle:titleArray[i-1] forState:UIControlStateNormal];
        }
        
//        scrollBtn.titleLabel.font = [UIFont systemFontOfSize:MiddleFont];
//        [scrollBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        //添加点击事件
        [scrollBtn addTarget:self action:@selector(scrollBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:scrollBtn];
        
    }
    
    //回调
    if (_clickBlock != clickBlock) {
        _clickBlock = clickBlock;
    }
    
    //计时器
    _timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(timerStart:) userInfo:nil repeats:YES];
    
    //当前偏移量
    _xOffset = height;
    [_scrollView setContentOffset:CGPointMake(0, _xOffset) animated:NO];
}

#pragma mark - 按钮点击事件
- (void) scrollBtnClick:(UIButton *) sender
{
    if (_clickBlock) {
        _clickBlock(sender.tag - 1000);
    }
}

#pragma mark - 计时器动作
- (void)timerStart:(NSTimer *)sender
{
    //   c abc a
    //如果当前显示第二个a，则将偏移量调整到第一个a的位置
    if (_xOffset == _scrollView.contentSize.height-_height) {
        _xOffset = _height;
        [_scrollView setContentOffset:CGPointMake(0, _xOffset) animated:NO];
    }

    //如果没有需要展示的轮播图，只有占位图的话，w w
    //    当前需要一直显示第二个w，不调整偏移量
    if (_scrollView.contentSize.height-_height != _height) {
        _xOffset += _height;
    }

    [_scrollView setContentOffset:CGPointMake(0, _xOffset) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _xOffset = scrollView.contentOffset.y;
    if (_xOffset == 0) {
        _xOffset = scrollView.contentSize.height-_height*2;
        [scrollView setContentOffset:CGPointMake(0, _xOffset) animated:NO];

    } else if (_xOffset == scrollView.contentSize.height-_height) {
        _xOffset = _height;
        [scrollView setContentOffset:CGPointMake(0, _xOffset) animated:NO];
    } else {

    }
}

@end
