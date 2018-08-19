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

@property (nonatomic, copy) EXPActualBoolBlock prerequisiteBlock;
@property (nonatomic, copy) EXPActualBoolBlock matchBlock;
@property (nonatomic, copy) EXPActualStringBlock failureMessageForToBlock;
@property (nonatomic, copy) EXPActualStringBlock failureMessageForNotToBlock;

@end
