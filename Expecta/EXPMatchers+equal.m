#import "EXPMatchers+equal.h"
#import "EXPMatcherHelpers.h"
#import "EXPDifference.h"

EXPMatcherImplementationBegin(_equal, (id expected)) {
  match(^BOOL(id actual) {
    if((actual == expected) || [actual isEqual:expected]) {
      return YES;
    } else if([actual isKindOfClass:[NSNumber class]] && [expected isKindOfClass:[NSNumber class]]) {
      if([actual isKindOfClass:[NSDecimalNumber class]] || [expected isKindOfClass:[NSDecimalNumber class]]) {
        NSDecimalNumber *actualDecimalNumber = [NSDecimalNumber decimalNumberWithDecimal:[(NSNumber *) actual decimalValue]];
        NSDecimalNumber *expectedDecimalNumber = [NSDecimalNumber decimalNumberWithDecimal:[(NSNumber *) expected decimalValue]];
        return [actualDecimalNumber isEqualToNumber:expectedDecimalNumber];
      }
      else {
        if(EXPIsNumberFloat((NSNumber *)actual) || EXPIsNumberFloat((NSNumber *)expected)) {
          return [(NSNumber *)actual floatValue] == [(NSNumber *)expected floatValue];
        }
      }
    }
    return NO;
  });

  failureMessageForTo(^NSString *(id actual) {
    NSString *expectedDescription = EXPDescribeObject(expected);
    NSString *actualDescription = EXPDescribeObject(actual);

    if (![expectedDescription isEqualToString:actualDescription]) {
      NSString *message = [NSString stringWithFormat:@"expected: %@, got: %@", EXPDescribeObject(expected), EXPDescribeObject(actual)];
      if ([expected respondsToSelector:@selector(differenceFrom:)]) {
        NSArray *difference = [expected differenceFrom:actual];
        return [NSString stringWithFormat:@"%@\n\n%@", [difference componentsJoinedByString:@"\n"], message];
      }
      return message;
    } else {
      return [NSString stringWithFormat:@"expected (%@): %@, got (%@): %@", NSStringFromClass([expected class]), EXPDescribeObject(expected), NSStringFromClass([actual class]), EXPDescribeObject(actual)];
    }
  });

  failureMessageForNotTo(^NSString *(id actual) {
    return [NSString stringWithFormat:@"expected: not %@, got: %@", EXPDescribeObject(expected), EXPDescribeObject(actual)];
  });
}
EXPMatcherImplementationEnd
