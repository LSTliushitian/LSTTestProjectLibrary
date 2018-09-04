//
//  HttpTool.m
//  TravelIndustry
//
//  Created by 刘士天 on 2018/5/19.
//  Copyright © 2018年 刘士天. All rights reserved.
//

#import "HttpTool.h"
#import "NSDictionary+DeleteNull.h"

@implementation HttpTool

+ (void)GET:(NSString *)url headers:(NSDictionary *)headers parameters:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager sharedHttpSessionManager];
    for (NSString * key in headers) {
        [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
    
    [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@", responseObject[@"statusCode"]] isEqualToString:@"1001"]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"statusMsg"]];
            UIViewController * vc =  [self getCuttentViewController];
            [vc dismissViewControllerAnimated:YES completion:nil];
            return ;
        } else if (success) {
            success([NSDictionary changeType:responseObject]);
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            NSLog(@"%@",error.description);
        }
    }];
    
}

+ (void)PUT:(NSString *)url headers:(NSDictionary *)headers parameters:(NSDictionary *)params success:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure {
    
    AFHTTPSessionManager * manager = [AFHTTPSessionManager sharedHttpSessionManager];
    for (NSString * key in headers) {
        [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
    
    [manager PUT:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@", responseObject[@"statusCode"]] isEqualToString:@"1001"]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"statusMsg"]];
            UIViewController * vc =  [self getCuttentViewController];
            [vc dismissViewControllerAnimated:YES completion:nil];
            return ;
        } else if (success) {
            success([NSDictionary changeType:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            NSLog(@"%@",error.description);
        }
    }];
    
}

+ (void) POST:(NSString *)url headers:(NSDictionary *)headers parameters:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager sharedHttpSessionManager];
    for (NSString * key in headers) {
        [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
    
    [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@", responseObject[@"statusCode"]] isEqualToString:@"1001"]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"statusMsg"]];
            UIViewController * vc =  [self getCuttentViewController];
            [vc dismissViewControllerAnimated:YES completion:nil];
            return ;
        } else if (success) {
            success([NSDictionary changeType:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            NSLog(@"%@",error.description);
        }
    }];
}

+ (void) POST:(NSString *)url headers:(NSDictionary *)headers parameters:(NSDictionary *)params constructingBodyWithBlock:(void (^)(id<AFMultipartFormData>))block success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager sharedHttpSessionManager];
    for (NSString * key in headers) {
        [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
    
    [manager POST:url parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (block) {
            block(formData);
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@", responseObject[@"statusCode"]] isEqualToString:@"1001"]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"statusMsg"]];
            UIViewController * vc =  [self getCuttentViewController];
            [vc dismissViewControllerAnimated:YES completion:nil];
            return ;
        } else if (success) {
            success([NSDictionary changeType:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            NSLog(@"%@",error.description);
        }
    }];
}

+ (void)DELETE:(NSString *)url headers:(NSDictionary *)headers parameters:(NSDictionary *)params success:(void (^)(id))success failure:(void (^)(NSError *))failure {
    AFHTTPSessionManager * manager = [AFHTTPSessionManager sharedHttpSessionManager];
    for (NSString * key in headers) {
        [manager.requestSerializer setValue:[headers objectForKey:key] forHTTPHeaderField:key];
    }
    
    [manager DELETE:url parameters:params success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if ([[NSString stringWithFormat:@"%@", responseObject[@"statusCode"]] isEqualToString:@"1001"]) {
            [SVProgressHUD showErrorWithStatus:responseObject[@"statusMsg"]];
            UIViewController * vc =  [self getCuttentViewController];
            [vc dismissViewControllerAnimated:YES completion:nil];
            return ;
        } else if (success) {
            success([NSDictionary changeType:responseObject]);
        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
            NSLog(@"%@",error.description);
        }
    }];
}

+ (id)getCuttentViewController
{
    UIViewController *vc = nil;
    
    UIWindow *window = [UIApplication sharedApplication].windows.firstObject;
    
    if ([window.rootViewController isKindOfClass:[UINavigationController class]])
    {
        vc = [(UINavigationController *)window.rootViewController visibleViewController];
    }
    else if ([window.rootViewController isKindOfClass:[UITabBarController class]])
    {
        UITabBarController *tabVC = (UITabBarController*)window.rootViewController;
        vc = [(UINavigationController *)[tabVC selectedViewController] visibleViewController];
    }
    else
    {
        vc = window.rootViewController;
    }
    return vc;
}

@end
