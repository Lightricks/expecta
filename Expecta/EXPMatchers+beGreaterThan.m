#import "EXPMatchers+beGreaterThan.h"
#import "EXPMatcherHelpers.h"

EXPMatcherImplementationBegin(_beGreaterThan, (id expected)) {
    match(^BOOL(id actual) {
        if ([actual respondsToSelector:@selector(compare:)]) {
            return [actual compare:expected] == NSOrderedDescending;
        }
        return NO;
    });

    failureMessageForTo(^NSString *(id actual) {
        return [NSString stringWithFormat:@"expected: %@ to be greater than %@", EXPDescribeObject(actual), EXPDescribeObject(expected)];
    });

    failureMessageForNotTo(^NSString *(id actual) {
        return [NSString stringWithFormat:@"expected: %@ not to be greater than %@", EXPDescribeObject(actual), EXPDescribeObject(expected)];
    });
}
EXPMatcherImplementationEnd
