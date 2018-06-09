//
//  GlobalDefine.h
//  LSTBasicDemo
//
//  Created by 兰科 on 2018/6/8.
//  Copyright © 2018年 兰科. All rights reserved.
//

#ifndef GlobalDefine_h
#define GlobalDefine_h

#import "Singleton.h"
#import "HttpTool.h"
#import "UserInfo.h"

#import <SVProgressHUD/SVProgressHUD.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>

#define SafeAreaTopHeight (SCREENHEIGHT == 812 ? 88 : 64)
#define SafeAreaBottomHeight (SCREENHEIGHT == 812 ? 83 : 49)

#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height

#define RGB(x, y, z) [UIColor colorWithRed:x/255.0 green:y/255.0 blue:z/255.0 alpha:1.0]
#define BasicColor RGB(17, 106, 202)

#define PIX SCREENWIDTH/720.0

//userDefault
#define UserDefault [NSUserDefaults standardUserDefaults]

//用户信息
#define UserData [UserInfo sharedUserInfo]

//版本号
#define updatebuild      [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]

#define YuMing @"http://"
#define FaildString @"网络请求失败"

#endif /* GlobalDefine_h */
