//
//  DCHMVVMCommand.m
//  DCHMVVMKit
//
//  Created by Derek Chen on 7/30/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import "DCHMVVMCommand.h"
#import "DCHMVVMCommandResult.h"
#import <libextobjc/EXTScope.h>

@interface DCHMVVMCommand ()

@property (nonatomic, strong) NSDictionary *buildinParams;
@property (nonatomic, assign) BOOL executing;
@property (nonatomic, strong) DCHMVVMCommandResult *result;

@property (nonatomic, copy) DCHMVVMCommandOperation operation;
@property (nonatomic, copy) DCHMVVMCommandCancelation cancelation;
@property (nonatomic, copy) DCHMVVMCommandCallback callback;
@property (nonatomic, copy) DCHMVVMCommandExecuteObserver executeObserver;

@end

@implementation DCHMVVMCommand

- (instancetype)initWithOperation:(DCHMVVMCommandOperation)operation {
    return [self initWithOperation:operation callback:nil];
}

- (instancetype)initWithOperation:(DCHMVVMCommandOperation)operation callback:(DCHMVVMCommandCallback)callback {
    return [self initWithOperation:operation callback:callback executeObserver:nil];
}

- (instancetype)initWithOperation:(DCHMVVMCommandOperation)operation callback:(DCHMVVMCommandCallback)callback executeObserver:(DCHMVVMCommandExecuteObserver)executeObserver {
    return [self initWithOperation:operation callback:callback executeObserver:executeObserver cancelation:nil];
}

- (instancetype)initWithOperation:(DCHMVVMCommandOperation)operation callback:(DCHMVVMCommandCallback)callback executeObserver:(DCHMVVMCommandExecuteObserver)executeObserver cancelation:(DCHMVVMCommandCancelation)cancelation {
    if (!operation) {
        return nil;
    }
    self = [self init];
    if (self) {
        self.operation = operation;
        self.callback = callback;
        self.executeObserver = executeObserver;
        self.cancelation = cancelation;
    }
    return self;
}

- (void)resetBuildinParams:(NSDictionary *)newBuildinParams {
    self.buildinParams = newBuildinParams;
}

- (void)cancel {
    if (self.cancelation) {
        self.cancelation();
    }
    self.executing = NO;
    if (self.executeObserver) {
        self.executeObserver(self.executing, self);
    }
}

- (void)syncExecute:(NSArray *)inputParams {
    if (!self.executing) {
        @weakify(self)
        self.executing = YES;
        if (self.executeObserver) {
            self.executeObserver(self.executing, self);
        }
        DCHMVVMCommandCompletion completion = ^(id content, NSError *error) {
            @strongify(self)
            DCHMVVMCommandResult *result = [[DCHMVVMCommandResult alloc] initWithContent:content andError:error];
            self.result = result;
            self.executing = NO;
        };
        self.operation(self.buildinParams, inputParams, completion);
    }
}

- (void)asyncExecute:(NSArray *)inputParams {
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        @strongify(self)
        [self syncExecute:inputParams];
    });
}

@end
