//
//  UIButton+QLTimeInterval.h
//  DEMO1
//
//  Created by qiu on 2018/11/5.
//  Copyright © 2018 QiuFairy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIButton (QLTimeInterval)
/* 防止button重复点击，设置间隔 */
@property (nonatomic, assign) NSTimeInterval ql_acceptEventInterval;
@end

NS_ASSUME_NONNULL_END
