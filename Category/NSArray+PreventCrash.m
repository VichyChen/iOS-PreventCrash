//
//  NSArray+PreventCrash.m
//  test
//
//  Created by Dajie Chen on 2019/12/6.
//  Copyright © 2019 Dajie Chen. All rights reserved.
//

#import "NSArray+PreventCrash.h"
#import <objc/runtime.h>

@implementation NSArray (PreventCrash)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getClass("__NSArrayI");
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(objectAtIndex:)),
                                       class_getInstanceMethod(class, @selector(pcObjectAtIndex:)));
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(objectAtIndexedSubscript:)),
                                       class_getInstanceMethod(class, @selector(pcObjectAtIndexedSubscript:)));
    });
}

- (id)pcObjectAtIndex:(NSUInteger)index {
    if (self.count <= index) {
        return nil;
    }
    return [self pcObjectAtIndex:index];
}

- (id)pcObjectAtIndexedSubscript:(NSUInteger)index {
    if (self.count <= index) {
        return nil;
    }
    return [self pcObjectAtIndexedSubscript:index];
}

@end
