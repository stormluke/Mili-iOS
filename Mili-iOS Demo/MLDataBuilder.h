#import <Foundation/Foundation.h>
#import <UIKit/UIColor.h>
#import "MLHelper.h"

@interface MLDataBuilder : NSObject

@property (nonatomic) NSUInteger pos;
@property (nonatomic) Byte *bytes;

- (instancetype)writeInt:(NSUInteger)value bytesCount:(NSUInteger)count;
- (instancetype)writeString:(NSString *)value bytesCount:(NSUInteger)count;
- (instancetype)writeVersionString:(NSString *)value;
- (instancetype)writeDate:(NSDate *)value;
- (instancetype)writeColorWithRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue blink:(BOOL)blink;
- (instancetype)writeChecksumFromIndex:(NSUInteger)index length:(NSUInteger)length lastMACByte:(NSUInteger)lastMACByte;
- (NSData *)data;

@end
