#import <Foundation/Foundation.h>

@interface MLLEParamsModel : NSObject

@property (nonatomic) NSUInteger connIntMin;
@property (nonatomic) NSUInteger connIntMax;
@property (nonatomic) NSUInteger latency;
@property (nonatomic) NSUInteger timeout;
@property (nonatomic) NSUInteger connInt;
@property (nonatomic) NSUInteger advInt;

- (instancetype)initWithData:(NSData *)data;
- (NSData *)data;

@end
