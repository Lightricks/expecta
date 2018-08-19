#import <Foundation/Foundation.h>

@interface EXPUnsupportedObject : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(NSString *)type NS_DESIGNATED_INITIALIZER;

@property (nonatomic, retain) NSString *type;

@end
