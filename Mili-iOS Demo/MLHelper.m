#import "MLHelper.h"

@implementation MLHelper

+ (NSUInteger)hexString2Int:(NSString *)value {
    unsigned result = 0;
    NSScanner *scanner = [NSScanner scannerWithString:value];
    [scanner scanHexInt:&result];
    return result;
}

+ (NSString *)byte2HexString:(Byte)value {
    if (value < 16) {
        return [NSString stringWithFormat:@"0%1x", value];
    } else {
        return [NSString stringWithFormat:@"%2x", value];
    }
}

+ (NSUInteger)CRC8WithBytes:(Byte*)bytes length:(NSUInteger)length {
    NSUInteger checksum = 0;
    for (NSUInteger i = 0; i < length; i++) {
        checksum ^= bytes[i];
        for (NSUInteger j = 0; j < 8; j++) {
            if (checksum & 0x1) {
                checksum = (0x8c ^ (0xff & checksum >> 1));
            } else {
                checksum = (0xff & checksum >> 1);
            }
        }
    }
    return checksum;
}

+ (MLCounter)counter:(NSUInteger)count withBlock:(void (^)())counterCallback {
    __block NSUInteger currentCount = 0;
    return ^void() {
        currentCount++;
        if (currentCount == count) {
            counterCallback();
        }
    };
}

@end
