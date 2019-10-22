#import "TestHelper.h"
#import "NSValue+Expecta.h"

@interface ExpectationTest : XCTestCase {
  NSNumber *n;
  NSValue *v;
}
@end

@interface ExpectedObject : NSObject

+ (NSUInteger)instanceCount;

@end

@implementation ExpectedObject

- (instancetype)init {
  if (self = [super init]) {
    ++_instanceCount;
  }
  return self;
}

- (void)dealloc {
  --_instanceCount;
  [super dealloc];
}

static NSUInteger _instanceCount;

+ (NSUInteger)instanceCount {
  return _instanceCount;
}

@end

@implementation ExpectationTest

- (void)test_expect {
  EXPExpect *x = expect(@"foo");
  x.completed = YES;
  assertEquals(x.lineNumber, (__LINE__ - 2));
  assertTrue(strcmp(x.fileName, __FILE__) == 0);
  assertEquals(x.testCase, self);
}

- (void)test_expect_NotTo {
  EXPExpect *x = expect(@"foo");
  x.completed = YES;
  assertFalse(x.negative);
  x = expect(@"foo").notTo;
  x.completed = YES;
  assertTrue(x.negative);
  x = expect(@"foo").toNot;
  x.completed = YES;
  assertTrue(x.negative);
}

- (void)test_expect_nil {
  EXPExpect *x = expect(nil);
  x.completed = YES;
  assertNil(x.actual);
}

- (void)test_expect_object {
  EXPExpect *x = expect(@"foo");
  x.completed = YES;
  assertEqualObjects(x.actual, @"foo");
}

- (void)test_expect_SEL {
  v = [NSValue valueWithPointer:@selector(description)];
  EXPExpect *x = expect(@selector(description));
  x.completed = YES;
  assertEqualObjects(x.actual, v);
  assertTrue(strcmp([(NSValue *)x.actual _EXP_objCType], @encode(SEL)) == 0);
}

- (void)test_expect_Class {
  EXPExpect *x = expect([EXPExpect class]);
  x.completed = YES;
  assertEqualObjects(x.actual, [EXPExpect class]);
}

- (void)test_expect_CString {
  char *foo = "foo";
  v = [NSValue valueWithPointer:foo];
  EXPExpect *x = expect(foo);
  x.completed = YES;
  assertEqualObjects(x.actual, v);
}

- (void)test_expect_char {
  char a = 127;
  n = @(a);
  EXPExpect *x = expect(a);
  x.completed = YES;
  assertEqualObjects(x.actual, n);
}

- (void)test_expect_double {
  double a = 3.141592653589793;
  n = @(a);
  EXPExpect *x = expect(a);
  x.completed = YES;
  assertEqualObjects(x.actual, n);
}

- (void)test_expect_float {
  float a = 3.141592f;
  n = @(a);
  EXPExpect *x = expect(a);
  x.completed = YES;
  assertEqualObjects(x.actual, n);
}

- (void)test_expect_int {
  int a = 2147483647;
  n = @(a);
  EXPExpect *x = expect(a);
  x.completed = YES;
  assertEqualObjects(x.actual, n);
}

- (void)test_expect_long {
#ifdef __LP64__
  long a = 9223372036854775807;
#else
  long a = 2147483647;
#endif
  n = @(a);
  EXPExpect *x = expect(a);
  x.completed = YES;
  assertEqualObjects(x.actual, n);
}

- (void)test_expect_long_long {
  long long a = 9223372036854775807;
  n = @(a);
  EXPExpect *x = expect(a);
  x.completed = YES;
  assertEqualObjects(x.actual, n);
}

- (void)test_expect_short {
  short a = 32767;
  n = @(a);
  EXPExpect *x = expect(a);
  x.completed = YES;
  assertEqualObjects(x.actual, n);
}

- (void)test_expect_NSInteger {
#ifdef __LP64__
  NSInteger a = 9223372036854775807;
#else
  NSInteger a = 2147483647;
#endif
  n = @(a);
  EXPExpect *x = expect(a);
  x.completed = YES;
  assertEqualObjects(x.actual, n);
}

- (void)test_expect_unsigned_char {
  unsigned char a = 255;
  n = @(a);
  EXPExpect *x = expect(a);
  x.completed = YES;
  assertEqualObjects(x.actual, n);
}

- (void)test_expect_unsigned_int {
  unsigned int a = 4294967295;
  n = @(a);
  EXPExpect *x = expect(a);
  x.completed = YES;
  assertEqualObjects(x.actual, n);
}

- (void)test_expect_unsigned_long {
#ifdef __LP64__
  unsigned long a = 18446744073709551615u;
#else
  unsigned long a = 4294967295;
#endif
  n = @(a);
  EXPExpect *x = expect(a);
  x.completed = YES;
  assertEqualObjects(x.actual, n);
}

- (void)test_expect_unsigned_long_long {
  unsigned long long a = 18446744073709551615u;
  n = @(a);
  EXPExpect *x = expect(a);
  x.completed = YES;
  assertEqualObjects(x.actual, n);
}

- (void)test_expect_unsigned_short {
  unsigned short a = 65535;
  n = @(a);
  EXPExpect *x = expect(a);
  x.completed = YES;
  assertEqualObjects(x.actual, n);
}

- (void)test_expect_NSUInteger {
#ifdef __LP64__
  NSUInteger a = 18446744073709551615u;
#else
  NSUInteger a = 4294967295;
#endif
  n = @(a);
  EXPExpect *x = expect(a);
  x.completed = YES;
  assertEqualObjects(x.actual, n);
}

- (void)test_expect_void_block {
  void (^b)(void) = ^{};
  EXPExpect *x = expect(b);
  x.completed = YES;
  assertEqualObjects(x.actual, b);
}

- (void)test_expect_parameter_block {
  void (^b)(int a) = ^(int a) {};
  EXPExpect *x = expect(b);
  x.completed = YES;
  assertEqualObjects(x.actual, b);
}

- (void)test_expect_union {
  union u {
    int a;
    float b;
  } u;
  assertFail(test_expect(u).beNil(), @"expecting a union is not supported");
}

- (void)test_expect_struct {
  struct s {
    int a;
    float b;
  } s;
  assertFail(test_expect(s).beNil(), @"expecting a struct is not supported");
}

- (void)test_boolean_type_equivalence {
  bool noBool = false;
  BOOL noBOOL = NO;
  int noInt = 0;
  id noNSNum = @NO;
  
  _Bool yesBool = true;
  BOOL yesBOOL = YES;
  int yesInt = 1;
  id yesNSNum = @YES;
  
  expect(false).to.equal(NO);
  expect(NO).to.equal(noBool);
  expect(noBool).to.equal(noBOOL);
  expect(noBOOL).to.equal(noInt);
  expect(noInt).to.equal(noNSNum);
  
  expect(true).to.equal(YES);
  expect(YES).to.equal(yesBool);
  expect(yesBool).to.equal(yesBOOL);
  expect(yesBOOL).to.equal(yesInt);
  expect(yesInt).to.equal(yesNSNum);
}

- (void)test_expect_memory_management {
  NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
  ExpectedObject *object = [[[ExpectedObject alloc] init] autorelease];
  expect(object).to.equal(object);
  [pool drain];

  assertEquals([ExpectedObject instanceCount], 0);
}

@end
