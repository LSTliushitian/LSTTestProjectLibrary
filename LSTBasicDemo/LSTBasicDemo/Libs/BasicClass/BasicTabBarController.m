//
//  BasicTabBarController.m
//  TravelIndustry
//
//  Created by 刘士天 on 2018/5/15.
//  Copyright © 2018年 刘士天. All rights reserved.
//

#import "BasicTabBarController.h"

@interface BasicTabBarController ()

@end

@implementation BasicTabBarController

+ (void)initialize
{
    if (self == [BasicTabBarController class]) {
        
        UITabBarItem *item=[UITabBarItem appearance];
        NSMutableDictionary *dict=[NSMutableDictionary dictionary];
        dict[NSFontAttributeName]=[UIFont systemFontOfSize:11];
        dict[NSForegroundColorAttributeName]= RGB(51, 51, 51);
        NSMutableDictionary *Selectdict=[NSMutableDictionary dictionary];
        Selectdict[NSFontAttributeName]=[UIFont systemFontOfSize:11];
        Selectdict[NSForegroundColorAttributeName] = BasicColor;
        
        [item setTitleTextAttributes:dict forState:UIControlStateNormal];
        [item setTitleTextAttributes:Selectdict forState:UIControlStateSelected];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //vc
    
    
    
    [self.tabBar setClipsToBounds:YES];// 去除顶部横线
    [self.tabBar insertSubview:({//自定义tabBar样式
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, SafeAreaBottomHeight)];
        backView.backgroundColor = [UIColor whiteColor];
        [backView addSubview:({
            UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREENWIDTH, 1)];
            lineView.backgroundColor = RGB(128, 128, 128);
            
            lineView;
        })];
        
        
        backView;
    }) atIndex:0];
    
    self.tabBar.opaque = YES;//不透明
    
    [self setSelectedIndex:1];//默认当前选择
}

- (void) addChildItemWithVC:(UIViewController *) vc itemTitle:(NSString *)itemTitle normalImage:(NSString *) normalImage selectedImage:(NSString *) selectedImage {
    
    vc.tabBarItem.title = itemTitle;
    vc.tabBarItem.image = [[UIImage imageNamed:normalImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    vc.tabBarItem.selectedImage = [[UIImage imageNamed:selectedImage] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];;
    
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
    
    [self addChildViewController:nav];
}

@end
