//
//  UserInfo.m
//  TravelIndustry
//
//  Created by 刘士天 on 2018/5/19.
//  Copyright © 2018年 刘士天. All rights reserved.
//

#import "UserInfo.h"

@implementation UserInfo

singleton_implementation(UserInfo)

- (NSDictionary *)headDic {
    return [UserDefault objectForKey:@"headDic"];
}

- (NSString *)itemId {
    return [UserDefault objectForKey:@"itemId"];
}

- (NSString *)userName {
    return [UserDefault objectForKey:@"userName"];
}

- (NSString *)hotelname {
    return [UserDefault objectForKey:@"hotelname"];
}

- (NSString *)hotelnumber {
    return [UserDefault objectForKey:@"hotelnumber"];
}

- (NSArray *)historyNameArr {
    return [UserDefault objectForKey:@"historyNameArr"];
}

@end
