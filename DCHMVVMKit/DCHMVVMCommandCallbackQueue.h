//
//  DCHMVVMCommandCallbackQueue.h
//  DCHMVVMKit
//
//  Created by Derek Chen on 8/11/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DCHMVVMCommandCallbackWarpper.h"

@class DCHMVVMCommandCallbackWarpper;
@class DCHMVVMCommandCallbackQueue;

typedef void(^DCHMVVMCommandCallbackQueueEnumeration)(DCHMVVMCommandCallbackQueue *queue, NSUInteger index, DCHMVVMCommandCallback callback);

@interface DCHMVVMCommandCallbackQueue : NSObject

- (NSString *)addCallback:(DCHMVVMCommandCallback)callback;
- (void)removeCallback:(NSString *)callbackUUID;
- (void)enumerate:(DCHMVVMCommandCallbackQueueEnumeration)enumeration;

@end
