//
//  ZYVersionUpdateManager.m
//  zy
//
//  Created by zy on 29/07/2019.
//  Copyright © 2019 zy. All rights reserved.
//

#import "ZYVersionUpdateManager.h"
#import "ZYVersionUpdateModel.h"
#import "ZYVersionUpdateView.h"
#import "LSTPopView.h"
#import <AFNetworking.h>

/// 企业包  "itms-services://?action=download-manifest&url=https://www-test.x.app/download/x.plist"
static NSString * _appID = @"414478124"; /// 微信id

@interface ZYVersionUpdateManager()

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

- (void)checkAppStoreVersionUpdate:(void(^)(BOOL success,NSString * msg))block {

    NSString * url = [NSString stringWithFormat:@"http://itunes.apple.com/cn/lookup?id=%@",_appID];
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
        
        ZYVersionUpdateModel * model = [self testModel]; // [ZYVersionUpdateModel yy_modelWithDictionary:dic];
        model.version = results[0][@"version"];
        model.content = results[0][@"releaseNotes"];
        model.url = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8",_appID];
        
        [self updateComparisonWithModel:model currentVersion:[self app_version] block:block];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        !block ?: block(false,error.description);
    }];
}

- (void)checkServiceVersionUpdate:(void(^)(BOOL success,NSString * msg))block {
    /// request
    ZYVersionUpdateModel * model = [self testModel]; // [ZYVersionUpdateModel yy_modelWithDictionary:dict];
    
    [self updateComparisonWithModel:model currentVersion:[self app_version]  block:block];
}

- (void)updateComparisonWithModel:(ZYVersionUpdateModel *)model
                   currentVersion:(NSString *)currentVersion
                            block:(void(^)(BOOL success,NSString * msg))block {
    
    NSComparisonResult result = [model.version compare:currentVersion options:NSNumericSearch];
    if (result == NSOrderedDescending) {
        [self showVersionUpdateViewModel:model];
        !block ?: block(true,nil);
    } else {
        !block ?: block(false,@"当前已是最新版本");
    }
}

- (void)showVersionUpdateViewModel:(ZYVersionUpdateModel *)model {
    ZYVersionUpdateView *view = [[ZYVersionUpdateView alloc] init];
    view.frame = CGRectMake(0, 0, 250, 300);
    view.model = model;
    LSTPopView *popView = [LSTPopView initWithCustomView:view parentView:nil popStyle:LSTPopStyleFade dismissStyle:LSTDismissStyleFade];
    popView.priority = 800;
    LSTPopViewWK(popView)
    LSTPopViewWK(self)
    popView.bgAlpha = 0.7;
    popView.popDuration = 0.8;
    popView.dismissDuration = 0.8;
    popView.isClickFeedback = YES;
    popView.isHideBg = NO;
    popView.isObserverScreenRotation = YES;
    view.sureBlock = ^{
        [wk_self versionUpdateUrl:model.url];
        [wk_popView dismiss];
    };
    view.cancelBlock = ^{
        [wk_popView dismiss];
    };
    popView.isClickBgDismiss = !model.force.boolValue;
    [popView pop];
}

- (void)versionUpdateUrl:(NSString *)urlString {
    NSURL * url = [NSURL URLWithString:urlString];
    /// 获取新版本的下载链接
    if ([UIApplication.sharedApplication canOpenURL:url]) {
        if (@available(iOS 10, *)) {
            [UIApplication.sharedApplication openURL: url
                                             options: @{}
                                   completionHandler: nil];
        } else {
            [UIApplication.sharedApplication openURL:url];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            //关闭程序
            exit(0);
        });
    }
}

- (NSString *)app_version {
    return [NSBundle.mainBundle objectForInfoDictionaryKey:@"CFBundleShortVersionString"];;
}

- (ZYVersionUpdateModel *)testModel {
    ZYVersionUpdateModel * model = ZYVersionUpdateModel.new;
    model.url = [NSString stringWithFormat:@"https://itunes.apple.com/us/app/id%@?ls=1&mt=8",@"444934666"];
    model.version = @"3.0.0";
    model.content = @"最新版本:3.0.0\n新版本大小:10M\n更新内容:test\n测试更新接口";
    model.force = @"0";
    return model;
}

@end
