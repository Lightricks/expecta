// Copyright (c) 2020 Lightricks. All rights reserved.
// Created by Maxim Grabarnik.

NS_ASSUME_NONNULL_BEGIN

/// Protocol for computing difference between objects.
@protocol EXPDifference <NSObject>

/// Returns an array of strings describing the difference between the receiver and the given
/// \c object. The differences detail what values were expected and what actual values are.
/// When the receiver and the given object are equal, an empty array is returned.
/// \c object must be of type similar enough to the receiver's so a comparison could be made.
/// Otherwise an exception is raised. In most cases the types must be the same, however for
/// collections it should be acceptable to compute difference between mutable and immutable ones.
///
/// @note per convention the receiver is to be treated as the "expected",
/// while the argument \c object is the "actual".

/// Example of a value type difference :
///
/// @code
/// @interface ValueTypeObject : NSObject<EXPDifference>
/// @(instancetype)initWithNumber:(int)number string:(NSString *)string;
/// @property (nonatomic) int number;
/// @property (nonatomic) NSString *string;
/// @end
///
/// auto expected = [[ValueTypeObject alloc] initWithNumber:10 string:@"something"];
/// auto actual = [[ValueTypeObject alloc] initWithNumber:5 string:@"something else"];
///
/// auto difference = [expected differenceFrom:actual];
/// @endcode
///
/// the value of the \c difference from the example should be as follows:
/// [@"number:",
///  @"  Expected: 10",
///  @"    Actual: 5",
///  @"string:",
///  @"  Expected: something",
///  @"    Actual: something else"]
- (NSArray<NSString *> *)differenceFrom:(id)object;

@end

NS_ASSUME_NONNULL_END
