//
//  ZJScrollLabelTool.h
//  车管家
//
//  Created by 张晶 on 2018/3/30.
//  Copyright © 2018年 zj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJScrollLabelTool : UIView

//本地文字
- (void)createScrollImgWithView:(UIView *)view backgroundColor:(UIColor *)backgroundColor titleArray:(NSArray *)titleArray width:(CGFloat)width height:(CGFloat)height ClickBlock:(void(^)(NSInteger clickIndex))clickBlock;

@end
