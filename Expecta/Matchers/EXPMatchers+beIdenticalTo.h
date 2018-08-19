#import "Expecta.h"

EXPMatcherInterface(_beIdenticalTo, (id expected));
EXPMatcherInterface(beIdenticalTo, (id expected)); // to aid code completion

#define beIdenticalTo(expected) _beIdenticalTo(expected)
