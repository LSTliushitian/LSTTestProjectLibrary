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

+ (instancetype) normalButtonWithFrame:(CGRect)rect font:(UIFont *)font norColor:(UIColor *)norColor norText:(NSString *)norText selColor:(UIColor *)selColor selText:(NSString *)selText clickBlock:(void (^)(UIButton *))clickBlock {
    
    LSTButton * button = [LSTButton buttonWithType:UIButtonTypeCustom];
    button.frame = rect;
    button.titleLabel.font = font;
    [button setTitleColor:norColor forState:UIControlStateNormal];
    [button setTitle:norText forState:UIControlStateNormal];
    [button setTitleColor:selColor forState:UIControlStateSelected];
    [button setTitle:selText forState:UIControlStateSelected];
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
