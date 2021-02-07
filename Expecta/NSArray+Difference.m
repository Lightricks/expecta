// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Maxim Grabarnik.

#import "NSArray+Difference.h"

#import <assert.h>

#import "ExpectaSupport.h"

NS_ASSUME_NONNULL_BEGIN

API_AVAILABLE(ios(13.0))
typedef NSOrderedCollectionChange<NSObject *> Change;

API_AVAILABLE(ios(13.0))
@interface ChangePair : NSObject

- (instancetype)init NS_UNAVAILABLE;

- (instancetype)initWithInsertion:(Change *)insertion removal:(Change *)removal;

@property (nonatomic, readonly) Change *insertion;

@property (nonatomic, readonly) Change *removal;

@end

@implementation ChangePair

- (instancetype)initWithInsertion:(Change *)insertion removal:(Change *)removal {
  if (self = [super init]) {
    _insertion = insertion;
    _removal = removal;
  }
  return self;
}

@end

@implementation NSArray (Difference)

- (NSArray<NSString *> *)differenceFrom:(nullable id)object
    API_AVAILABLE(ios(13.0)) {
  if (!object) {
    return @[@"Expected: NSArray, got: nil"];
  }

  if (![object isKindOfClass:[NSArray class]]) {
    return @[
      [NSString stringWithFormat:@"Expected: NSArray, got: %@", NSStringFromClass([object class])]
    ];
  }

  NSArray *expected = self;
  NSArray *actual = (NSArray *)object;

  NSOrderedCollectionDifference<NSObject *> *diff = [expected differenceFromArray:actual withOptions:NSOrderedCollectionDifferenceCalculationInferMoves];

  NSMutableArray *mismatches = [NSMutableArray array];
  NSMutableArray *reorders = [NSMutableArray array];
  NSMutableSet *usedInsertions = [NSMutableSet set];
  NSMutableSet *usedRemovals = [NSMutableSet set];
  for (Change *insertion in diff.insertions) {
    for (Change *removal in diff.removals) {
      if (insertion.index == removal.index) {
        [mismatches addObject:[[ChangePair alloc] initWithInsertion:insertion removal:removal]];
        [usedInsertions addObject:@(insertion.index)];
        [usedRemovals addObject:@(removal.index)];
      }
      if (insertion.associatedIndex == removal.index) {
        assert(removal.associatedIndex == insertion.index);
        [reorders addObject:[[ChangePair alloc] initWithInsertion:insertion removal:removal]];
        [usedInsertions addObject:@(insertion.index)];
        [usedRemovals addObject:@(removal.index)];
      }
    }
  }

  NSMutableArray *differences = [NSMutableArray array];
  if (expected.count != actual.count) {
    [differences addObject:[NSString stringWithFormat:@"Different count: expected (%lu), actual (%lu)",
                            expected.count, actual.count]];
  }

  for (ChangePair *mismatch in mismatches) {
    [differences addObject:[NSString stringWithFormat:@"Mismatch at index (%lu)",
                            mismatch.insertion.index]];
    if ([mismatch.insertion.object respondsToSelector:@selector(differenceFrom:)]) {
      NSArray<NSString *> *diffLines = [(id)mismatch.insertion.object differenceFrom:mismatch.removal.object];
      [differences addObject:[NSString stringWithFormat:@"Expected type %@ differenceFrom: actual type %@:",
                              NSStringFromClass([mismatch.insertion.object class]),
                              NSStringFromClass([mismatch.removal.object class])]];
      for (NSString *line in diffLines) {
        [differences addObject:[NSString stringWithFormat:@"\t%@", line]];
      }
    }
    else {
      [differences addObjectsFromArray:@[
        [NSString stringWithFormat:@"\tExpected: (%@)",
         EXPDescribeObject(mismatch.insertion.object)],
        [NSString stringWithFormat:@"\tActual: (%@)", EXPDescribeObject(mismatch.removal.object)]
      ]];
    }
  }

  for (ChangePair *reorder in reorders) {
    [differences addObjectsFromArray:@[
      [NSString stringWithFormat:@"Wrong index for value: (%@)",
       EXPDescribeObject(reorder.insertion.object)],
      [NSString stringWithFormat:@"\tExpected at index (%lu)", reorder.insertion.index],
      [NSString stringWithFormat:@"\tActual index is (%lu)", reorder.removal.index]
    ]];
  }

  for (Change *removal in diff.removals) {
    if ([usedRemovals containsObject:@(removal.index)]) {
      continue;
    }

    [differences addObjectsFromArray:@[
      @"Actual contains extra item",
      [NSString stringWithFormat:@"\tindex: (%lu)", removal.index],
      [NSString stringWithFormat:@"\tvalue: (%@)", EXPDescribeObject(actual[removal.index])]
    ]];
  }

  for (Change *insertion in diff.insertions) {
    if ([usedInsertions containsObject:@(insertion.index)]) {
      continue;
    }

    [differences addObjectsFromArray:@[
      [NSString stringWithFormat:@"Actual misses an item at index (%lu)", insertion.index],
      [NSString stringWithFormat:@"\tExpected: (%@)", EXPDescribeObject(expected[insertion.index])]
    ]];
  }

  return differences;
}

@end

NS_ASSUME_NONNULL_END
