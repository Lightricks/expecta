#import <Foundation/Foundation.h>

@interface EXPDoubleTuple : NSObject

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDoubleValues:(const double *)values size:(size_t)size
    NS_DESIGNATED_INITIALIZER;

@property (nonatomic, assign) double *values;
@property (nonatomic, assign) size_t size;

@end
