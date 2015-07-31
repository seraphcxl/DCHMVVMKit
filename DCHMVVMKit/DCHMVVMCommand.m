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

- (void)updateExecuting:(BOOL)executing;

@end

@implementation DCHMVVMCommand

- (instancetype)initWithOperation:(DCHMVVMCommandOperation)operation {
    return [self initWithOperation:operation cancelation:nil];
}

- (instancetype)initWithOperation:(DCHMVVMCommandOperation)operation cancelation:(DCHMVVMCommandCancelation)cancelation {
    if (!operation) {
        return nil;
    }
    self = [self init];
    if (self) {
        self.operation = operation;
        self.cancelation = cancelation;
    }
    return self;
}

- (void)resetBuildinParams:(NSDictionary *)newBuildinParams {
    self.buildinParams = newBuildinParams;
}

- (void)resetCallback:(DCHMVVMCommandCallback)newCallback {
    self.callback = newCallback;
}

- (void)resetExecuteObserver:(DCHMVVMCommandExecuteObserver)newExecuteObserver {
    self.executeObserver = newExecuteObserver;
}

- (void)cancel {
    if (self.cancelation) {
        self.cancelation();
    }
    [self updateExecuting:NO];
}

- (void)syncExecute:(NSArray *)inputParams {
    if (!self.executing) {
        @weakify(self)
        [self updateExecuting:YES];
        DCHMVVMCommandCompletion completion = ^(id content, NSError *error) {
            @strongify(self) 
            DCHMVVMCommandResult *result = [[DCHMVVMCommandResult alloc] initWithContent:content andError:error];
            self.result = result;
            if (self.callback) {
                self.callback(self, result);
            }
            [self updateExecuting:NO];
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

- (void)updateExecuting:(BOOL)executing {
    self.executing = executing;
    if (self.executeObserver) {
        self.executeObserver(self, self.executing);
    }
}

@end
