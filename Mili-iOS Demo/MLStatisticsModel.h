#import <Foundation/Foundation.h>

@interface MLStatisticsModel : NSObject

@property (nonatomic) NSUInteger wake;
@property (nonatomic) NSUInteger vibrate;
@property (nonatomic) NSUInteger light;
@property (nonatomic) NSUInteger conn;
@property (nonatomic) NSUInteger adv;

- (instancetype)initWithData:(NSData *)data;
- (NSData *)data;

@end
