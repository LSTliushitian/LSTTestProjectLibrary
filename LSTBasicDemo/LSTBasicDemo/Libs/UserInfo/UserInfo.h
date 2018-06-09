//
//  UserInfo.h
//  TravelIndustry
//
//  Created by 刘士天 on 2018/5/19.
//  Copyright © 2018年 刘士天. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject

singleton_interface(UserInfo);

@property (strong, nonatomic) NSDictionary * headDic;//头字典
@property (strong, nonatomic) NSArray * historyNameArr;//历史用户名

@property (strong, nonatomic) NSString * itemId;//itemId
@property (strong, nonatomic) NSString * userName;//userName

@property (strong, nonatomic) NSString * hotelname;//商户名称
@property (strong, nonatomic) NSString * hotelnumber;//商户编号

@end
