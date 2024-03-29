//
//  UIButton+QLTimeInterval.m
//  DEMO1
//
//  Created by qiu on 2018/11/5.
//  Copyright © 2018 QiuFairy. All rights reserved.
//

#import "UIButton+QLTimeInterval.h"
#import <objc/runtime.h>
@implementation UIButton (QLTimeInterval)
static const char *UIButton_acceptEventInterval = "UIButton_acceptEventInterval";
static const char *UIButton_acceptEventTime     = "UIButton_acceptEventTime";

- (NSTimeInterval )ql_acceptEventInterval{
    return [objc_getAssociatedObject(self, UIButton_acceptEventInterval) doubleValue];
}

- (void)setQl_acceptEventInterval:(NSTimeInterval)ql_acceptEventInterval{
    objc_setAssociatedObject(self, UIButton_acceptEventInterval, @(ql_acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSTimeInterval )ql_acceptEventTime{
    return [objc_getAssociatedObject(self, UIButton_acceptEventTime) doubleValue];
}

- (void)setQl_acceptEventTime:(NSTimeInterval)ql_acceptEventTime{
    objc_setAssociatedObject(self, UIButton_acceptEventTime, @(ql_acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

+ (void)load{
    //获取这两个方法
    Method systemMethod = class_getInstanceMethod(self, @selector(sendAction:to:forEvent:));
    SEL sysSEL = @selector(sendAction:to:forEvent:);
    
    Method myMethod = class_getInstanceMethod(self, @selector(ql_sendAction:to:forEvent:));
    SEL mySEL = @selector(ql_sendAction:to:forEvent:);
    
    //添加方法进去
    BOOL didAddMethod = class_addMethod(self, sysSEL, method_getImplementation(myMethod), method_getTypeEncoding(myMethod));
    
    //如果方法已经存在
    if (didAddMethod) {
        class_replaceMethod(self, mySEL, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
    }else{
        method_exchangeImplementations(systemMethod, myMethod);
        
    }
    
    /*-----以上主要是实现两个方法的互换,load是gcd的只shareinstance，保证执行一次-------*/
    
}

- (void)ql_sendAction:(SEL)action to:(id)target forEvent:(UIEvent *)event{
    
    if (NSDate.date.timeIntervalSince1970 - self.ql_acceptEventTime < self.ql_acceptEventInterval) {
        return;
    }
    
    if (self.ql_acceptEventInterval > 0) {
        self.ql_acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    
    [self ql_sendAction:action to:target forEvent:event];
}

@end
