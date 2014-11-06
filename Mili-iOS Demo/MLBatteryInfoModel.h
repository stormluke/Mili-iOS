#import <Foundation/Foundation.h>

@interface MLBatteryInfoModel : NSObject

@property (nonatomic) NSUInteger level;
@property (nonatomic, strong) NSDate *lastCharge;
@property (nonatomic) NSUInteger chargesCount;
@property (nonatomic) NSUInteger status;

- (instancetype)initWithData:(NSData *)data;
- (NSData *)data;

@end
