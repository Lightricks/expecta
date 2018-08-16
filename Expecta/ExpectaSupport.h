#import "EXPExpect.h"
#import "EXPBlockDefinedMatcher.h"

#ifdef __cplusplus
extern "C" {
#endif

id _EXPObjectify(const char *type, void *value);
EXPExpect *_EXP_expect(id testCase, int lineNumber, const char *fileName, EXPIdBlock actualBlock);

void EXPFail(id testCase, int lineNumber, const char *fileName, NSString *message);
NSString *EXPDescribeObject(id obj);

void EXP_prerequisite(EXPActualBoolBlock block);
void EXP_match(EXPActualBoolBlock block);
void EXP_failureMessageForTo(EXPActualStringBlock block);
void EXP_failureMessageForNotTo(EXPActualStringBlock block);

#if __has_feature(objc_arc)
#define _EXP_release(x)
#define _EXP_autorelease(x) (x)

#else
#define _EXP_release(x) [x release]
#define _EXP_autorelease(x) [x autorelease]
#endif

// workaround for the categories bug: http://developer.apple.com/library/mac/#qa/qa1490/_index.html
#define EXPFixCategoriesBug(name) \
__attribute__((constructor)) static void EXPFixCategoriesBug##name() {}

#define _EXPMatcherInterface(matcherName, matcherArguments) \
@interface EXPExpect (matcherName##Matcher) \
@property (nonatomic, readonly) void(^ matcherName) matcherArguments; \
@end

#define _EXPMatcherImplementationBegin(matcherName, matcherArguments) \
EXPFixCategoriesBug(EXPMatcher##matcherName##Matcher); \
@implementation EXPExpect (matcherName##Matcher) \
@dynamic matcherName;\
- (void(^) matcherArguments) matcherName { \
  EXPBlockDefinedMatcher *matcher = [[EXPBlockDefinedMatcher alloc] init]; \
  [[[NSThread currentThread] threadDictionary] setObject:matcher forKey:@"EXP_currentMatcher"]; \
  __block void (^prerequisite)(EXPActualBoolBlock block) = ^(EXPActualBoolBlock block) { EXP_prerequisite(block); }; \
  __block void (^match)(EXPActualBoolBlock block) = ^(EXPActualBoolBlock block) { EXP_match(block); }; \
  __block void (^failureMessageForTo)(EXPActualStringBlock block) = ^(EXPActualStringBlock block) { EXP_failureMessageForTo(block); }; \
  __block void (^failureMessageForNotTo)(EXPActualStringBlock block) = ^(EXPActualStringBlock block) { EXP_failureMessageForNotTo(block); }; \
  prerequisite(nil); match(nil); failureMessageForTo(nil); failureMessageForNotTo(nil); \
  void (^matcherBlock) matcherArguments = [^ matcherArguments { \
    {

#define _EXPMatcherImplementationEnd \
    } \
    [self applyMatcher:matcher]; \
    [[[NSThread currentThread] threadDictionary] removeObjectForKey:@"EXP_currentMatcher"]; \
  } copy]; \
  _EXP_release(matcher); \
  return _EXP_autorelease(matcherBlock); \
} \
@end

#define _EXPMatcherAliasImplementation(newMatcherName, oldMatcherName, matcherArguments) \
EXPFixCategoriesBug(EXPMatcher##newMatcherName##Matcher); \
@implementation EXPExpect (newMatcherName##Matcher) \
@dynamic newMatcherName;\
- (void(^) matcherArguments) newMatcherName { \
  return [self oldMatcherName]; \
}\
@end

#ifdef __cplusplus
}
#endif
