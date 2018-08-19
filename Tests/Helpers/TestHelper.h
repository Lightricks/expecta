#import <Foundation/Foundation.h>
#import <XCTest/XCTest.h>
#define EXP_SHORTHAND
#import "Expecta.h"
#import "FakeTestCase.h"
#import "EXPExpect+Test.h"
#import "Fixtures.h"

#define IGNORE_RETAIN_SELF_BEGIN \
  _Pragma("clang diagnostic push") \
  _Pragma("clang diagnostic ignored \"-Wimplicit-retain-self\"")

#define IGNORE_RETAIN_SELF_END \
  _Pragma("clang diagnostic pop")

#define assertPass(expr) \
  IGNORE_RETAIN_SELF_BEGIN \
  XCTAssertNoThrow((expr)); \
  IGNORE_RETAIN_SELF_END

#define assertFail(expr, message...) \
  IGNORE_RETAIN_SELF_BEGIN \
  XCTAssertThrowsSpecificNamed(expr, NSException, ## message); \
  IGNORE_RETAIN_SELF_END

#define assertEquals(a, b) XCTAssertEqual((a), (b))
#define assertEqualObjects(a, b) XCTAssertEqualObjects((a), (b))
#define assertTrue(a) XCTAssertTrue((a))
#define assertFalse(a) XCTAssertFalse((a))
#define assertNil(a) XCTAssertNil((a))

#define test_expect(a) [expect(a) test]
