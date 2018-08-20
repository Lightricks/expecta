#import "NSValue+Expecta.h"
#import <objc/runtime.h>
#import "Expecta.h"

@implementation NSValue (Expecta)

- (const char *)_EXP_objCType {
  return [(NSString *)objc_getAssociatedObject(self, _cmd)
          cStringUsingEncoding:NSUTF8StringEncoding];
}

- (void)set_EXP_objCType:(const char *)_EXP_objCType {
  objc_setAssociatedObject(self, @selector(_EXP_objCType),
                           @(_EXP_objCType), OBJC_ASSOCIATION_COPY_NONATOMIC);
}

@end
