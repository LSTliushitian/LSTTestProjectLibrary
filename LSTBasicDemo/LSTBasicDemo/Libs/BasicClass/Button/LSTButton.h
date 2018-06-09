//
//  LSTButton.h
//  LSTBasicDemo
//
//  Created by 兰科 on 2018/6/8.
//  Copyright © 2018年 兰科. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LSTButton : UIButton

#pragma mark - 普通文字按钮
+ (instancetype) normalButtonWithFrame:(CGRect)rect font:(UIFont *)font norColor:(UIColor *)norColor norText:(NSString *)norText selColor:(UIColor *)selColor selText:(NSString *)selText clickBlock:(void(^)(UIButton * sender))clickBlock;

@end
