#import <Foundation/Foundation.h>
#import "EXPMatcher.h"
#import "EXPDefines.h"

@interface EXPExpect : NSObject

@property(nonatomic, copy) EXPIdBlock actualBlock;
@property(nonatomic, readonly) id actual;
@property(nonatomic) id testCase;
@property(nonatomic) int lineNumber;
@property(nonatomic) const char *fileName;
@property(nonatomic) BOOL negative;
@property(nonatomic) BOOL asynchronous;
@property(nonatomic) NSTimeInterval timeout;

@property(nonatomic, readonly) EXPExpect *to;
@property(nonatomic, readonly) EXPExpect *toNot;
@property(nonatomic, readonly) EXPExpect *notTo;
@property(nonatomic, readonly) EXPExpect *will;
@property(nonatomic, readonly) EXPExpect *willNot;
@property(nonatomic, readonly) EXPExpect *(^after)(NSTimeInterval timeInterval);

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithActualBlock:(id)actualBlock testCase:(id)testCase lineNumber:(int)lineNumber fileName:(const char *)fileName NS_DESIGNATED_INITIALIZER;
+ (EXPExpect *)expectWithActualBlock:(id)actualBlock testCase:(id)testCase lineNumber:(int)lineNumber fileName:(const char *)fileName;

- (void)applyMatcher:(id<EXPMatcher>)matcher;

@end

@interface EXPDynamicPredicateMatcher : NSObject <EXPMatcher>

@property (readonly, nonatomic) SEL selector;
@property (readonly, nonatomic) EXPExpect *expectation;
@property (nonatomic, readonly, copy) void (^dispatch)(void);

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithExpectation:(EXPExpect *)expectation selector:(SEL)selector NS_DESIGNATED_INITIALIZER;

@end
