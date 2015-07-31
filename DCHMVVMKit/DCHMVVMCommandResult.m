//
//  DCHMVVMCommandResult.m
//  DCHMVVMKit
//
//  Created by Derek Chen on 7/30/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import "DCHMVVMCommandResult.h"

@interface DCHMVVMCommandResult ()

@property (nonatomic, strong) NSError *error;
@property (nonatomic, strong) id content;

@end

@implementation DCHMVVMCommandResult

- (instancetype)initWithContent:(id)content andError:(NSError *)error {
    self = [self init];
    if (self) {
        self.content = content;
        self.error = error;
    }
    return self;
}

@end
