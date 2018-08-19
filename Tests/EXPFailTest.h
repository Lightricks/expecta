// Test case class without failWithException: method
@interface TestCaseClassWithoutFailMethod : NSObject
- (void)fail;
@end

// Test case class with failWithException: method
@interface TestCaseClassWithFailMethod : TestCaseClassWithoutFailMethod {
  NSException *_exception;
}

@property (nonatomic, retain) NSException *exception;
- (void)failWithException:(NSException *)exception;

@end

// Test case class with failWithException: method
@interface TestCaseClassWithRecordFailureMethod : TestCaseClassWithoutFailMethod

@property (nonatomic, strong) NSString *failureDescription;
@property (nonatomic, strong) NSString *fileName;
@property (assign) NSUInteger lineNumber;
@property (assign) BOOL expected;

- (void)recordFailureWithDescription:(NSString *)failureDescription inFile:(NSString *)filename
                              atLine:(NSUInteger)lineNumber expected:(BOOL)expected;

@end
