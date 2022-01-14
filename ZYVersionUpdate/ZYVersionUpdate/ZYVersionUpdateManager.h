//
//  ZYVersionUpdateManager.h
//  zy
//
//  Created by zy on 29/07/2019.
//  Copyright © 2019 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYVersionUpdateManager : NSObject

/** 创建单例 */
+ (instancetype)shared;

/// 检测商店更新
/// @param block (void(^)(BOOL success,NSString * msg))
- (void)checkAppStoreVersionUpdate:(void(^)(BOOL success,NSString * msg))block;

/// 检测服务器更新
/// @param block (void(^)(BOOL success,NSString * msg))
- (void)checkServiceVersionUpdate:(void(^)(BOOL success,NSString * msg))block;


@end

NS_ASSUME_NONNULL_END
