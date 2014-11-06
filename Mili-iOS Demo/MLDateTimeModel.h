#import <Foundation/Foundation.h>

@interface MLDateTimeModel : NSObject

@property (nonatomic, strong) NSDate *newerDate;
@property (nonatomic, strong) NSDate *olderDate;

- (instancetype)initWithData:(NSData *)data;
- (NSData *)data;

@end
