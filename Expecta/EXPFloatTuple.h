#import <Foundation/Foundation.h>

@interface EXPFloatTuple : NSObject

- (instancetype)initWithFloatValues:(const float *)values size:(size_t)size
    NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@property (nonatomic, assign) float *values;
@property (nonatomic, assign) size_t size;

@end
