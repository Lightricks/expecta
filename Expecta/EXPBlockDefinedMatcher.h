//
//  EXPRuntimeMatcher.h
//  Expecta
//
//  Created by Luke Redpath on 26/03/2012.
//  Copyright (c) 2012 Peter Jihoon Kim. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "EXPMatcher.h"
#import "EXPDefines.h"

@interface EXPBlockDefinedMatcher : NSObject <EXPMatcher>

- (instancetype)initWithPrerequisiteBlock:(EXPActualBoolBlock)prerequisiteBlock
                               matchBlock:(EXPActualBoolBlock)matchBlock
                 failureMessageForToBlock:(EXPActualStringBlock)failureMessageForToBlock
              failureMessageForNotToBlock:(EXPActualStringBlock)failureMessageForNotToBlock
    NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@property(nonatomic, readonly) EXPActualBoolBlock prerequisiteBlock;
@property(nonatomic, readonly) EXPActualBoolBlock matchBlock;
@property(nonatomic, readonly) EXPActualStringBlock failureMessageForToBlock;
@property(nonatomic, readonly) EXPActualStringBlock failureMessageForNotToBlock;

@end
