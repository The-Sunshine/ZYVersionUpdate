//
//  ZYVersionUpdateModel.h
//  zy
//
//  Created by zy on 29/07/2019.
//  Copyright © 2019 zy. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface ZYVersionUpdateModel : NSObject

@property (nonatomic,strong) NSString * version;
@property (nonatomic,strong) NSString * force;
@property (nonatomic,strong) NSString * url;
@property (nonatomic,strong) NSString * content;

@end

NS_ASSUME_NONNULL_END
