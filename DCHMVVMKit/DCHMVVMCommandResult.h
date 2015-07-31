//
//  DCHMVVMCommandResult.h
//  DCHMVVMKit
//
//  Created by Derek Chen on 7/30/15.
//  Copyright (c) 2015 CHEN. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DCHMVVMCommandResult : NSObject

@property (nonatomic, strong, readonly) NSError *error;
@property (nonatomic, strong, readonly) id content;

- (instancetype)initWithContent:(id)content andError:(NSError *)error;

@end
