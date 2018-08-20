//
//  EXPRuntimeMatcher.m
//  Expecta
//
//  Created by Luke Redpath on 26/03/2012.
//  Copyright (c) 2012 Peter Jihoon Kim. All rights reserved.
//

#import "EXPBlockDefinedMatcher.h"

@interface EXPBlockDefinedMatcher ()
@property(nonatomic, copy) EXPActualBoolBlock prerequisiteBlock;
@property(nonatomic, copy) EXPActualBoolBlock matchBlock;
@property(nonatomic, copy) EXPActualStringBlock failureMessageForToBlock;
@property(nonatomic, copy) EXPActualStringBlock failureMessageForNotToBlock;
@end

@implementation EXPBlockDefinedMatcher

- (instancetype)initWithPrerequisiteBlock:(EXPActualBoolBlock)prerequisiteBlock
                               matchBlock:(EXPActualBoolBlock)matchBlock
                 failureMessageForToBlock:(EXPActualStringBlock)failureMessageForToBlock
              failureMessageForNotToBlock:(EXPActualStringBlock)failureMessageForNotToBlock {
  if (self = [super init]) {
    self.prerequisiteBlock = prerequisiteBlock;
    self.matchBlock = matchBlock;
    self.failureMessageForToBlock = failureMessageForToBlock;
    self.failureMessageForNotToBlock = failureMessageForNotToBlock;
  }
  return self;
}

- (BOOL)meetsPrerequisiteFor:(id)actual {
  if (self.prerequisiteBlock) {
    return self.prerequisiteBlock(actual);
  }
  return YES;
}

- (BOOL)matches:(id)actual {
  if (self.matchBlock) {
    return self.matchBlock(actual);
  }
  return YES;
}

- (NSString *)failureMessageForTo:(id)actual {
  if (self.failureMessageForToBlock) {
    return self.failureMessageForToBlock(actual);
  }
  return nil;
}

- (NSString *)failureMessageForNotTo:(id)actual {
  if (self.failureMessageForNotToBlock) {
    return self.failureMessageForNotToBlock(actual);
  }
  return nil;
}

@end
