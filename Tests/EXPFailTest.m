#import "TestHelper.h"
#import "EXPFailTest.h"

@interface EXPExpectFailTest : XCTestCase
@property (nonatomic, copy) NSString *fileName;
@property (nonatomic, copy) NSString *errorDescription;
@property (assign) NSUInteger lineNumber;
@end

@implementation EXPExpectFailTest

// This test is dependent on the LOC with the failure on
static NSInteger EXPFailTestLine = 28;

- (void)recordFailureWithDescription:(NSString *)description inFile:(NSString *)filePath atLine:(NSUInteger)lineNumber expected:(BOOL)expected
{
    if (lineNumber != EXPFailTestLine) {
        [super recordFailureWithDescription:description inFile:filePath atLine:lineNumber expected:expected];
    } else {
        self.fileName = filePath;
        self.lineNumber = lineNumber;
        self.errorDescription = description;
    }
}

- (void)test_ExpectFailToFail
{
    failure(@"Expect Fail to Fail");

    assertEqualObjects(self.errorDescription, @"Expect Fail to Fail");
    assertTrue([self.fileName hasSuffix:@"EXPFailTest.m"]);
    assertEqualObjects(@(self.lineNumber), @(EXPFailTestLine));
}

@end

@implementation TestCaseClassWithoutFailMethod

- (void)fail {
  EXPFail(self, 777, "test.m", @"epic fail");
}

@end

@implementation TestCaseClassWithFailMethod

- (void)failWithException:(NSException *)exception {
  self.exception = exception;
}

@end

@implementation TestCaseClassWithRecordFailureMethod

- (void)recordFailureWithDescription:(NSString *)failureDescription inFile:(NSString *)filename
                              atLine:(NSUInteger)lineNumber expected:(BOOL)expected {
  _failureDescription = failureDescription;
  _fileName = filename;
  _lineNumber = lineNumber;
  _expected = expected;
}

@end
    
@interface EXPFailTest : XCTestCase
@end

@implementation EXPFailTest

- (void)test_EXPFailWithTestCaseClassThatDoesNotHaveFailureMethod {
  // it throws the exception directly
  TestCaseClassWithoutFailMethod *testCase = [TestCaseClassWithoutFailMethod new];
  @try {
    [testCase fail];
  } @catch(NSException *exception) {
    assertEqualObjects([exception name], @"Expecta Error");
    assertEqualObjects([exception reason], @"test.m:777 epic fail");
  }
}

- (void)test_EXPFailWithTestCaseClassThatHasFailureMethod {
    // it calls recordFailureWithDescription:inFile:atLine:expected: method
    TestCaseClassWithRecordFailureMethod *testCase = [TestCaseClassWithRecordFailureMethod new];
    assertNil(testCase.failureDescription);
    assertNil(testCase.fileName);
    [testCase fail];
    assertEqualObjects(testCase.failureDescription, @"epic fail");
    assertEqualObjects(testCase.fileName, @"test.m");
    assertEqualObjects(@(testCase.lineNumber), @777);
    assertEquals(testCase.expected, NO);
}

@end
