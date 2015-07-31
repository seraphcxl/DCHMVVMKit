//
//  DCHMVVMCommandCallbackWarpper.m
//  DCHMVVMKit
//
//  Created by Derek Chen on 7/30/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import "DCHMVVMCommandCallbackWarpper.h"
#include "DCHMVVMCommand.h"

@interface DCHMVVMCommandCallbackWarpper ()

@property (nonatomic, copy) DCHMVVMCommandCallback callback;

@end

@implementation DCHMVVMCommandCallbackWarpper

- (instancetype)initWithCommandCallback:(DCHMVVMCommandCallback)callback {
    if (!callback) {
        return nil;
    }
    self = [self init];
    if (self) {
        self.callback = callback;
    }
    return self;
}

@end
