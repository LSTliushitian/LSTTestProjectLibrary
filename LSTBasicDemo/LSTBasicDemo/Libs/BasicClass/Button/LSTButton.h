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
+ (instancetype) normalButtonWithFrame:(CGRect)rect fontSize:(CGFloat)fontSize textColor:(UIColor *)textColor text:(NSString *)text backColor:(UIColor *)backColor clickBlock:(void(^)(UIButton * sender))clickBlock;

@end
