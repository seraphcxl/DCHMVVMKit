//
//  DCHMVVMCommand.h
//  DCHMVVMKit
//
//  Created by Derek Chen on 7/30/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCHMVVMCommandCallbackWarpper.h"
#import "DCHMVVMCommandCallbackQueue.h"

@class DCHMVVMCommandResult;
@class DCHMVVMCommand;

typedef void(^DCHMVVMCommandCompletion)(id content, NSError *error);
typedef void(^DCHMVVMCommandOperation)(NSDictionary *buildinParams, NSArray *inputParams, DCHMVVMCommandCompletion completion);
typedef void(^DCHMVVMCommandCancelation)();
typedef void(^DCHMVVMCommandExecuteObserver)(DCHMVVMCommand *command, BOOL executing);

@interface DCHMVVMCommand : NSObject

@property (nonatomic, strong, readonly) NSDictionary *buildinParams;
@property (nonatomic, assign, readonly) BOOL executing;
@property (nonatomic, strong, readonly) DCHMVVMCommandResult *result;

- (instancetype)initWithOperation:(DCHMVVMCommandOperation)operation;
- (instancetype)initWithOperation:(DCHMVVMCommandOperation)operation callback:(DCHMVVMCommandCallback)callback;
- (instancetype)initWithOperation:(DCHMVVMCommandOperation)operation callback:(DCHMVVMCommandCallback)callback cancelation:(DCHMVVMCommandCancelation)cancelation;

- (void)resetBuildinParams:(NSDictionary *)newBuildinParams;
- (void)resetExecuteObserver:(DCHMVVMCommandExecuteObserver)newExecuteObserver;

- (NSString *)resetCallback:(DCHMVVMCommandCallback)newCallback;
- (NSString *)addCallback:(DCHMVVMCommandCallback)callback;
- (void)enumerateCallback:(DCHMVVMCommandCallbackQueueEnumeration)enumeration;

- (void)cancel;
- (void)syncExecute:(NSArray *)inputParams;
- (void)asyncExecute:(NSArray *)inputParams;

@end
