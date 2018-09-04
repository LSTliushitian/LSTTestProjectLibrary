//
//  HttpTool.h
//  TravelIndustry
//
//  Created by 刘士天 on 2018/5/19.
//  Copyright © 2018年 刘士天. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AFNetworking.h>

@interface HttpTool : NSObject

+ (void)GET:(NSString *)url headers:(NSDictionary *)headers parameters:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)PUT:(NSString *)url headers:(NSDictionary *)headers parameters:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)POST:(NSString *)url headers:(NSDictionary *)headers parameters:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)DELETE:(NSString *)url headers:(NSDictionary *)headers parameters:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

+ (void)POST:(NSString *)url headers:(NSDictionary *)headers parameters:(NSDictionary*)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData> formData))block success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;


@end
