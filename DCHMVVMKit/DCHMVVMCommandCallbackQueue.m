//
//  DCHMVVMCommandCallbackQueue.m
//  DCHMVVMKit
//
//  Created by Derek Chen on 8/11/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import "DCHMVVMCommandCallbackQueue.h"
#import <Tourbillon/DCHTourbillon.h>

@interface DCHMVVMCommandCallbackQueue ()

@property (nonatomic, strong) NSMutableArray *callbackArray;

@end

@implementation DCHMVVMCommandCallbackQueue

- (instancetype)init {
    self = [super init];
    if (self) {
        self.callbackArray = [NSMutableArray array];
    }
    return self;
}

- (NSString *)addCallback:(DCHMVVMCommandCallback)callback {
    NSString *result = nil;
    do {
        if (!callback) {
            break;
        }
        DCHMVVMCommandCallbackWarpper *warpper = [[DCHMVVMCommandCallbackWarpper alloc] initWithCommandCallback:callback];
        if (!warpper) {
            break;
        }
        [self.callbackArray dch_safe_addObject:warpper];
        result = warpper.uuid;
    } while (NO);
    return result;
}

- (void)removeCallback:(NSString *)callbackUUID {
    do {
        if (DCH_IsEmpty(callbackUUID)) {
            break;
        }
        DCHMVVMCommandCallbackWarpper *warpper = nil;
        for (DCHMVVMCommandCallbackWarpper *callbackWarpper in self.callbackArray) {
            if ([callbackWarpper.uuid isEqualToString:callbackUUID]) {
                warpper = callbackWarpper;
                break;
            }
        }
        if (DCH_IsEmpty(warpper)) {
            break;
        }
        [self.callbackArray dch_safe_removeObject:warpper];
    } while (NO);
}

- (void)enumerate:(DCHMVVMCommandCallbackQueueEnumeration)enumeration {
    do {
        if (!enumeration) {
            break;
        }
        NSUInteger idx = 0;
        for (DCHMVVMCommandCallbackWarpper *callbackWarpper in self.callbackArray) {
            if (enumeration) {
                enumeration(self, idx, callbackWarpper.callback);
            }
            
            ++idx;
        }
    } while (NO);
}

@end
