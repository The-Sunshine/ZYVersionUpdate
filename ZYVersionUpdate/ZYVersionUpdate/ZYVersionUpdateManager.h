//
//  ZYVersionUpdateManager.h
//  zy
//
//  Created by zy on 29/07/2019.
//  Copyright © 2019 zy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZYVersionUpdateModel.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYVersionUpdateManager : NSObject

/// 检测商店更新
/// @param appID NSString
/// /// @param force NSString 是否强制更新
/// @param block (void(^)(BOOL success,NSString * msg))
+ (void)checkAppStoreVersionUpdateWithAppID:(NSString *)appID
                                      force:(BOOL)force
                                 customView:(UIView *)customView
                                      block:(void(^)(BOOL success,NSString * msg))block;

/// 自定义更新
/// @param model ZYVersionUpdateModel
/// @param block (void(^)(BOOL success,NSString * msg))
/// 企业包url规则  "itms-services://?action=download-manifest&url=https://www-test.x.app/download/x.plist"
+ (void)updateComparisonWithModel:(ZYVersionUpdateModel *)model
                       customView:(UIView *)customView
                            block:(void(^)(BOOL success,NSString * msg))block;

/// 确定更新后的打开url逻辑
/// @param urlString NSString
+ (void)versionUpdateUrl:(NSString *)urlString;

/// 隐藏弹窗
+ (void)dismiss;

#ifdef DEBUG
/// 测试model，仅debug使用
+ (ZYVersionUpdateModel *)testModel;
#endif

@end

NS_ASSUME_NONNULL_END
