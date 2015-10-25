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
#import <Tourbillon/DCHTourbillon.h>

@interface DCHMVVMCommand ()

@property (nonatomic, strong) NSDictionary *buildinParams;
@property (nonatomic, assign) BOOL executing;
@property (nonatomic, strong) DCHMVVMCommandResult *result;
@property (nonatomic, strong) id storeContent;

@property (nonatomic, copy) DCHMVVMCommandOperation operation;
@property (nonatomic, copy) DCHMVVMCommandCancelation cancelation;
@property (nonatomic, copy) DCHMVVMCommandCallbackQueue *callbackQueue;
@property (nonatomic, copy) DCHMVVMCommandExecuteObserver executeObserver;

- (void)updateExecuting:(BOOL)executing;
- (void)execute:(NSDictionary *)inputParams synchronous:(BOOL)sync;

@end

@implementation DCHMVVMCommand

- (void)dealloc {
    self.callbackQueue = nil;
    self.executeObserver = nil;
    self.cancelation = nil;
    self.operation = nil;
    
    self.storeContent = nil;
    self.result = nil;
    self.buildinParams = nil;
}

- (instancetype)initWithOperation:(DCHMVVMCommandOperation)operation {
    return [self initWithOperation:operation callback:nil];
}

- (instancetype)initWithOperation:(DCHMVVMCommandOperation)operation callback:(DCHMVVMCommandCallback)callback {
    return [self initWithOperation:operation callback:callback cancelation:nil];
}

- (instancetype)initWithOperation:(DCHMVVMCommandOperation)operation callback:(DCHMVVMCommandCallback)callback cancelation:(DCHMVVMCommandCancelation)cancelation {
    if (!operation) {
        return nil;
    }
    self = [self init];
    if (self) {
        self.operation = operation;
        self.cancelation = cancelation;
        
        self.callbackQueue = [[DCHMVVMCommandCallbackQueue alloc] init];
        if (callback) {
            [self.callbackQueue addCallback:callback];
        }
    }
    return self;
}

- (void)resetBuildinParams:(NSDictionary *)newBuildinParams {
    self.buildinParams = newBuildinParams;
}

- (void)resetExecuteObserver:(DCHMVVMCommandExecuteObserver)newExecuteObserver {
    self.executeObserver = newExecuteObserver;
}

- (NSString *)resetCallback:(DCHMVVMCommandCallback)newCallback {
    NSString *result = nil;
    do {
        self.callbackQueue = [[DCHMVVMCommandCallbackQueue alloc] init];
        if (newCallback) {
            result = [self.callbackQueue addCallback:newCallback];
        }
    } while (NO);
    return result;
}

- (NSString *)addCallback:(DCHMVVMCommandCallback)callback {
    NSString *result = nil;
    do {
        if (callback) {
            result = [self.callbackQueue addCallback:callback];
        }
    } while (NO);
    return result;
}

- (void)enumerateCallback:(DCHMVVMCommandCallbackQueueEnumeration)enumeration {
    do {
        if (enumeration) {
            [self.callbackQueue enumerate:enumeration];
        }
    } while (NO);
}

- (void)cancel {
    if (self.cancelation) {
        self.cancelation(self.storeContent);
    }
    [self updateExecuting:NO];
    self.storeContent = nil;
}

- (void)execute:(NSDictionary *)inputParams synchronous:(BOOL)sync {
    if (!self.executing) {
        @weakify(self)
        [self updateExecuting:YES];
        DCHMVVMCommandCompletion completion = ^(id content, NSError *error) {
            @strongify(self)
            DCHMVVMCommandResult *result = [[DCHMVVMCommandResult alloc] initWithContent:content andError:error];
            self.result = result;
            [NSThread dch_run:^{
                @strongify(self)
                if (self.callbackQueue) {
                    [self.callbackQueue enumerate:^(DCHMVVMCommandCallbackQueue *queue, NSUInteger index, DCHMVVMCommandCallback callback) {
                        @strongify(self)
                        do {
                            if (callback) {
                                callback(self, result);
                            }
                        } while (NO);
                    }];
                }
            } synchronous:sync];
            [self updateExecuting:NO];
            self.storeContent = nil;
        };
        self.storeContent = self.operation(self.buildinParams, inputParams, completion);
    }
}

- (void)syncExecute:(NSDictionary *)inputParams {
    [self execute:inputParams synchronous:YES];
}

- (void)asyncExecute:(NSDictionary *)inputParams {
    @weakify(self)
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        @strongify(self)
        [self execute:inputParams synchronous:NO];
    });
}

- (void)updateExecuting:(BOOL)executing {
    self.executing = executing;
    if (self.executeObserver) {
        self.executeObserver(self, self.executing);
    }
}

@end
