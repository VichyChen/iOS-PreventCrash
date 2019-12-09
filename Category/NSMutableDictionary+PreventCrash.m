//
//  NSMutableDictionary+PreventCrash.m
//  test
//
//  Created by Dajie Chen on 2019/12/9.
//  Copyright © 2019 Dajie Chen. All rights reserved.
//

#import "NSMutableDictionary+PreventCrash.h"
#import <objc/runtime.h>

@implementation NSMutableDictionary (PreventCrash)

+(void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getClass("__NSDictionaryM");
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(setObject:forKey:)),
                                       class_getInstanceMethod(class, @selector(pcSetObject:forKey:)));
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(setObject:forKeyedSubscript:)),
                                       class_getInstanceMethod(class, @selector(pcSetObject:forKeyedSubscript:)));
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(removeObjectForKey:)),
                                       class_getInstanceMethod(class, @selector(pcRemoveObjectForKey:)));
    });
}

- (void)pcSetObject:(id)anObject forKey:(id <NSCopying>)aKey {
    if (!anObject) {
        return;
    }
    if (!aKey) {
        return;
    }
    [self pcSetObject:anObject forKey:aKey];
}

- (void)pcSetObject:(id)obj forKeyedSubscript:(id <NSCopying>)key {
    if (!key) {
        return;
    }
    [self pcSetObject:obj forKeyedSubscript:key];
}

- (void)pcRemoveObjectForKey:(id)aKey {
    if (!aKey) {
        return;
    }
    [self pcRemoveObjectForKey:aKey];
}

@end
