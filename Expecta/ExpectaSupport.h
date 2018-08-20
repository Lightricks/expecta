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

#define _EXPMatcherInterface(matcherName, matcherArguments) \
@interface EXPExpect (matcherName##Matcher) \
@property (nonatomic, readonly) void(^ matcherName) matcherArguments; \
@end

#define _EXPMatcherImplementationBegin(matcherName, matcherArguments) \
@implementation EXPExpect (matcherName##Matcher) \
@dynamic matcherName;\
- (void(^) matcherArguments) matcherName { \
  __block EXPActualBoolBlock _prerequisiteBlock; \
  __block EXPActualBoolBlock _matchBlock; \
  __block EXPActualStringBlock _failureMessageForToBlock; \
  __block EXPActualStringBlock _failureMessageForNotToBlock; \
  __block id<EXPMatcher> _matcher; \
  \
  __unused void (^prerequisite)(EXPActualBoolBlock block) = ^(EXPActualBoolBlock block) { _prerequisiteBlock = block; }; \
  __unused void (^match)(EXPActualBoolBlock block) = ^(EXPActualBoolBlock block) { _matchBlock = block; }; \
  __unused void (^failureMessageForTo)(EXPActualStringBlock block) = ^(EXPActualStringBlock block) { _failureMessageForToBlock = block; }; \
  __unused void (^failureMessageForNotTo)(EXPActualStringBlock block) = ^(EXPActualStringBlock block) { _failureMessageForNotToBlock = block; }; \
  \
  void (^_matcherBlock) matcherArguments = [^ matcherArguments { \
    {

#define _EXPMatcherImplementationEnd \
    } \
    _matcher = [[EXPBlockDefinedMatcher alloc] initWithPrerequisiteBlock:_prerequisiteBlock \
        matchBlock:_matchBlock failureMessageForToBlock:_failureMessageForToBlock \
        failureMessageForNotToBlock:_failureMessageForNotToBlock]; \
    [self applyMatcher:_matcher]; \
  } copy]; \
  return _matcherBlock; \
} \
@end

#define _EXPMatcherAliasImplementation(newMatcherName, oldMatcherName, matcherArguments) \
@implementation EXPExpect (newMatcherName##Matcher) \
@dynamic newMatcherName;\
- (void(^) matcherArguments) newMatcherName { \
  return [self oldMatcherName]; \
}\
@end

#ifdef __cplusplus
}
#endif
