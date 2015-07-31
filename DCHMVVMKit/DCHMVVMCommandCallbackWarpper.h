//
//  DCHMVVMCommandCallbackWarpper.h
//  DCHMVVMKit
//
//  Created by Derek Chen on 7/30/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DCHMVVMCommand;

typedef void(^DCHMVVMCommandCallback)(DCHMVVMCommand *command);

@interface DCHMVVMCommandCallbackWarpper : NSObject

@property (nonatomic, copy, readonly) DCHMVVMCommandCallback callback;

- (instancetype)initWithCommandCallback:(DCHMVVMCommandCallback)callback;

@end
