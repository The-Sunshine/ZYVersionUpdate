//
//  ZYVersionUpdateManager.m
//  zy
//
//  Created by zy on 29/07/2019.
//  Copyright © 2019 zy. All rights reserved.
//

#import "ZYVersionUpdateManager.h"

#if __has_include(<LSTPopView/LSTPopView.h>)
#import <LSTPopView.h>
#else
#import "LSTPopView.h"
#endif

#if __has_include(<AFNetworking/AFNetworking.h>)
#import <AFNetworking.h>
#else
#import "AFNetworking.h"
#endif

@interface ZYVersionUpdateManager()

@property (nonatomic,strong) LSTPopView * popView;

@end

@implementation ZYVersionUpdateManager

+ (instancetype)shared{
    static ZYVersionUpdateManager *manager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[self alloc] init];
    });
    return manager;
}

+ (void)checkAppStoreVersionUpdateWithAppID:(NSString *)appID
                                      force:(BOOL)force
                                 customView:(UIView *)customView
                                      block:(void(^)(BOOL success,NSString * msg))block {

    NSString * url = [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",appID];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/javascript", nil];
    [manager POST:url parameters:nil headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSArray * results = responseObject[@"results"];
        if (!results.count) {
            !block ?: block(false,@"当前已是最新版本");
            return;
        }
        
        ZYVersionUpdateModel * model = ZYVersionUpdateModel.new;
        model.version = results[0][@"version"];
        model.content = results[0][@"releaseNotes"];
        model.url = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8",appID];
        model.force = force ? @"1" : @"0";
        [self updateComparisonWithModel:model customView:customView block:block];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !block ?: block(false,error.description);
    }];
}

+ (void)updateComparisonWithModel:(ZYVersionUpdateModel *)model
                       customView:(UIView *)customView
                            block:(void(^)(BOOL success,NSString * msg))block {
    
    NSComparisonResult result = [model.version compare:[ZYVersionUpdateManager app_version] options:NSNumericSearch];
    if (result == NSOrderedDescending) {
        [self showVersionUpdateViewModel:model customView:customView];
        !block ?: block(true,nil);
    } else {
        !block ?: block(false,@"当前已是最新版本");
    }
}

+ (void)showVersionUpdateViewModel:(ZYVersionUpdateModel *)model
                        customView:(UIView *)customView {

    LSTPopView * popView = [LSTPopView initWithCustomView:customView
                                              parentView:nil
                                                popStyle:LSTPopStyleFade
                                            dismissStyle:LSTDismissStyleFade];
    popView.priority = 800;
    popView.bgAlpha = 0.7;
    popView.popDuration = 0.8;
    popView.dismissDuration = 0.8;
    popView.isClickFeedback = YES;
    popView.isHideBg = NO;
    popView.isObserverScreenRotation = YES;
    popView.isClickBgDismiss = !model.force.boolValue;
    [popView pop];
    ZYVersionUpdateManager.shared.popView = popView;
}

+ (void)dismiss {
    [ZYVersionUpdateManager.shared.popView dismiss];
}

+ (void)versionUpdateUrl:(NSString *)urlString {
    
    NSURL * url = [NSURL URLWithString:urlString];
    if (![UIApplication.sharedApplication canOpenURL:url]) return;
    [UIApplication.sharedApplication openURL: url
                                     options: @{}
                           completionHandler: nil];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        //关闭程序
        exit(0);
    });
}

+ (ZYVersionUpdateModel *)testModel {
    ZYVersionUpdateModel * model = ZYVersionUpdateModel.new;
    model.url = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8",@"444934666"];
    model.version = @"100.0.0";
    model.content = @"最新版本:3.0.0\n新版本大小:10M\n更新内容:test\n测试更新接口";
    model.force = @"0";
    return model;
}

#pragma mark - private
+ (NSString *)app_version {
    return [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];;
}

@end
