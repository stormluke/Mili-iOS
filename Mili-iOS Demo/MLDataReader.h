#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>

@interface MLDataReader : NSObject

@property (nonatomic) NSUInteger pos;
@property (nonatomic) Byte *bytes;
@property (nonatomic) NSUInteger length;

- (instancetype)initWithData:(NSData *)data;
- (instancetype)appendData:(NSData *)data;
- (instancetype)rePos:(NSUInteger)pos;
- (NSUInteger)bytesLeftCount;
- (NSUInteger)readInt:(NSUInteger)bytesCount;
- (NSInteger)readSensorData;
- (NSString *)readString:(NSUInteger)bytesCount;
- (NSString *)readVersionString;
- (NSDate *)readDate;
- (NSString *)readMACAddressString;

@end
