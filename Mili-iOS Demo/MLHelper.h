#import "MLDataBuilder.h"
#import "MLDataReader.h"
#import "MLActivityDataReader.h"

typedef void (^MLCounter)();

@interface MLHelper : NSObject

+ (NSUInteger)hexString2Int:(NSString *)value;
+ (NSString *)byte2HexString:(Byte)value;
+ (NSUInteger)CRC8WithBytes:(Byte *)bytes length:(NSUInteger)length;
+ (MLCounter)counter:(NSUInteger)count withBlock:(void (^)())counterCallback;

@end