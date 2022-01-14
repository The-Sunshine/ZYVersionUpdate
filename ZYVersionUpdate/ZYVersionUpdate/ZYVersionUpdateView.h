//
//  ZYVersionUpdateView.h
//  
//
//  Created by zy on 2021/12/26.
//  Copyright © 2021 zy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZYVersionUpdateModel.h"

NS_ASSUME_NONNULL_BEGIN

typedef void(^ZYVersionUpdateViewSureBlock)(void);
typedef void(^ZYVersionUpdateViewCancelBlock)(void);

@interface ZYVersionUpdateView : UIView

@property (nonatomic, copy) ZYVersionUpdateViewSureBlock sureBlock;

@property (nonatomic, copy) ZYVersionUpdateViewCancelBlock cancelBlock;

@property (nonatomic, strong) ZYVersionUpdateModel * model;

@end

NS_ASSUME_NONNULL_END
