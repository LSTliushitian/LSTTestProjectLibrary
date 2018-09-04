//
//  LSTButton.m
//  LSTBasicDemo
//
//  Created by 兰科 on 2018/6/8.
//  Copyright © 2018年 兰科. All rights reserved.
//

#import "LSTButton.h"

@interface LSTButton ()

@property (nonatomic, strong) void(^clickBlock)(UIButton * sender);

@end

@implementation LSTButton

+ (instancetype) normalButtonWithFrame:(CGRect)rect fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor text:(NSString *)text backColor:(UIColor *)backColor clickBlock:(void (^)(UIButton *))clickBlock {
    
    LSTButton * button = [LSTButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.titleLabel.font = [UIFont systemFontOfSize:fontSize];
    [button setTitleColor:textColor forState:UIControlStateNormal];
    [button setTitle:text forState:UIControlStateNormal];
    button.backgroundColor = backColor;
    
    [button addTarget:button action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if (clickBlock) {
        button.clickBlock = clickBlock;
    }
    
    return button;
}

- (void) buttonClick:(UIButton *) sender {
    if (self.clickBlock) {
        self.clickBlock(sender);
    }
}

@end
