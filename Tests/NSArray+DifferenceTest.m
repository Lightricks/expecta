// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Maxim Grabarnik.

#import "NSArray+Difference.h"

#import "EXPDifference.h"
#import "TestHelper.h"

@interface EXPDifferent : NSObject<EXPDifference>
@end

@implementation EXPDifferent

- (BOOL)isEqual:(id)object {
  return NO;
}

- (nonnull NSArray<NSString *> *)differenceFrom:(nullable id)object {
  return @[@"wink-wink"];
}

@end

@interface NSArray_DifferenceTest : XCTestCase
@end

@implementation NSArray_DifferenceTest

- (void)test_equals_return_empty_diff {
  NSArray *difference = [@[@1, @2, @3] differenceFrom:@[@1, @2, @3]];
  assertTrue(difference.count == 0);
}

- (void)test_mismatch_item {
  NSArray *difference = [@[@1, @2, @1, @4] differenceFrom:@[@1, @2, @3, @4]];
  assertTrue(([difference isEqualToArray:@[
    @"Mismatch at index (2)",
    @"\tExpected: (1)",
    @"\tActual: (3)"
  ]]));
}

- (void)test_mismatch_differencable_item {
  NSArray *difference = [@[@1, [[EXPDifferent alloc] init], @3] differenceFrom:@[@1, [[EXPDifferent alloc] init], @3]];
  assertTrue(([difference isEqualToArray:@[
    @"Mismatch at index (1)",
    @"Expected type EXPDifferent differenceFrom: actual type EXPDifferent:",
    @"\twink-wink"
  ]]));
}

- (void)test_extra_item {
  NSArray *difference = [@[@1, @3, @4] differenceFrom:@[@1, @2, @3, @4]];
  assertTrue(([difference isEqualToArray:@[
    @"Different count: expected (3), actual (4)",
    @"Actual contains extra item",
    @"\tindex: (1)",
    @"\tvalue: (2)"
  ]]));
}

- (void)test_missing_item {
  NSArray *difference = [@[@1, @2, @8, @3, @4] differenceFrom:@[@1, @2, @3, @4]];
  assertTrue(([difference isEqualToArray:@[
    @"Different count: expected (5), actual (4)",
    @"Actual misses an item at index (2)",
    @"\tExpected: (8)"
  ]]));
}

- (void)test_reordered_item {
  NSArray *difference = [@[@2, @1, @3, @4] differenceFrom:@[@1, @2, @3, @4]];
  assertTrue(([difference isEqualToArray:@[
    @"Wrong index for value: (1)",
    @"\tExpected at index (1)",
    @"\tActual index is (0)"
  ]]));
}

- (void)test_all_types_of_changes {
  NSArray *difference = [@[@3, @6, @1, @9, @4] differenceFrom:@[@1, @2, @3, @4, @5]];
  assertTrue(([difference isEqualToArray:@[
    @"Mismatch at index (1)",
    @"\tExpected: (6)",
    @"\tActual: (2)",
    @"Wrong index for value: (1)",
    @"\tExpected at index (2)",
    @"\tActual index is (0)",
    @"Actual contains extra item",
    @"\tindex: (4)",
    @"\tvalue: (5)",
    @"Actual misses an item at index (3)",
    @"\tExpected: (9)"
  ]]));
}

@end
