//
//  NSDictionary+PreventCrash.m
//  test
//
//  Created by Dajie Chen on 2019/12/9.
//  Copyright © 2019 Dajie Chen. All rights reserved.
//

#import "NSDictionary+PreventCrash.h"
#import <objc/runtime.h>

@implementation NSDictionary (PreventCrash)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = objc_getClass("__NSPlaceholderDictionary");
        method_exchangeImplementations(class_getInstanceMethod(class, @selector(initWithObjects:forKeys:count:)),
                                       class_getInstanceMethod(class, @selector(pcInitWithObjects:forKeys:count:)));
    });
}

- (instancetype)pcInitWithObjects:(const id _Nonnull [])objects forKeys:(const id <NSCopying> _Nonnull [])keys count:(NSUInteger)cnt {
    id instance = nil;
    @try {
        instance = [self pcInitWithObjects:objects forKeys:keys count:cnt];
    }
    @catch (NSException *exception) {
        NSUInteger index = 0;
        id _Nonnull __unsafe_unretained newObjects[cnt];
        id _Nonnull __unsafe_unretained newKeys[cnt];
        for (int i = 0; i < cnt; i++) {
            if (objects[i] && keys[i]) {
                newObjects[index] = objects[i];
                newKeys[index] = keys[i];
                index++;
            } else {
                //
            }
        }
        instance = [self pcInitWithObjects:newObjects forKeys:newKeys count:index];
    }
    @finally {
        return instance;
    }
}

@end
