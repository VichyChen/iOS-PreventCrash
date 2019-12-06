//
//  NSMutableArray+PreventCrash.m
//  test
//
//  Created by Dajie Chen on 2019/12/6.
//  Copyright © 2019 Dajie Chen. All rights reserved.
//

#import "NSMutableArray+PreventCrash.h"
#import <objc/runtime.h>

@implementation NSMutableArray (PreventCrash)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getClass("__NSArrayM");
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(objectAtIndex:)),
                                       class_getInstanceMethod(class, @selector(pcObjectAtIndex:)));
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(objectAtIndexedSubscript:)),
                                       class_getInstanceMethod(class, @selector(pcObjectAtIndexedSubscript:)));
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(addObject:)),
                                       class_getInstanceMethod(class, @selector(pcAddObject:)));
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(insertObject:atIndex:)),
                                       class_getInstanceMethod(class, @selector(pcInsertObject:atIndex:)));
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(removeObject:)),
                                       class_getInstanceMethod(class, @selector(pcRemoveObject:)));
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(removeObjectAtIndex:)),
                                       class_getInstanceMethod(class, @selector(pcRemoveObjectAtIndex:)));
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(replaceObjectAtIndex:withObject:)),
                                       class_getInstanceMethod(class, @selector(pcReplaceObjectAtIndex:withObject:)));
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

- (void)pcAddObject:(id)anObject {
    if (!anObject) {
        return;
    }
    [self pcAddObject:anObject];
}

- (void)pcInsertObject:(id)anObject atIndex:(NSUInteger)index {
    if (!anObject) {
        return;
    } else if (self.count < index) {
        return;
    } else {
        [self pcInsertObject:anObject atIndex:index];
    }
}

- (void)pcRemoveObject:(id)anObject {
    if (!anObject) {
        return;
    }
    [self pcRemoveObject:anObject];
}

- (void)pcRemoveObjectAtIndex:(NSUInteger)index {
    if (self.count <= index) {
        return;
    }
    [self pcRemoveObjectAtIndex:index];
}

- (void)pcReplaceObjectAtIndex:(NSUInteger)index withObject:(id)anObject {
    if (self.count <= index) {
        return;
    }
    if (!anObject) {
        return;
    }
    [self pcReplaceObjectAtIndex:index withObject:anObject];
}

@end
