#import "MLDataBuilder.h"

@implementation MLDataBuilder

- (instancetype)init {
    self = [super init];
    if (self) {
        _bytes = [NSMutableData dataWithLength:sizeof(Byte) * 20].mutableBytes;
    }
    return self;
}

- (instancetype)writeInt:(NSUInteger)value bytesCount:(NSUInteger)count {
    for (NSUInteger i = 0; i < count; i++) {
        _bytes[_pos++] = 0xff & value >> (i * 8);
    }
    return self;
}

- (instancetype)writeString:(NSString *)value bytesCount:(NSUInteger)count {
    NSInteger endPos = _pos + count;
    NSString *validString = [value stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    Byte *stringBytes = (Byte *)[validString dataUsingEncoding:NSUTF8StringEncoding].bytes;
    for (NSUInteger i = 0; i < MIN(count, validString.length); i++) {
        _bytes[_pos + i] = stringBytes[i];
    }
    _pos = endPos;
    return self;
}

- (instancetype)writeVersionString:(NSString *)value {
    NSScanner *scanner = [[NSScanner alloc] initWithString:value];
    int result = 0;
    for (NSInteger i = 3; i >= 0; i--) {
        int byte = 0;
        [scanner scanInt:&byte];
        result |= byte << (i * 8);
    }
    [self writeInt:result bytesCount:4];
    return self;
}

- (instancetype)writeDate:(NSDate *)value {
    if (value) {
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond) fromDate:value];
        [self writeInt:(components.year - 2000) bytesCount:1];
        [self writeInt:(components.month - 1) bytesCount:1];
        [self writeInt:components.day bytesCount:1];
        [self writeInt:components.hour bytesCount:1];
        [self writeInt:components.minute bytesCount:1];
        [self writeInt:components.second bytesCount:1];
    } else {
        for (NSUInteger i = 0; i < 6; i++) {
            [self writeInt:0xff bytesCount:1];
        }
    }
    return self;
}

- (instancetype)writeColorWithRed:(NSUInteger)red green:(NSUInteger)green blue:(NSUInteger)blue blink:(BOOL)blink {
    [self writeInt:red bytesCount:1];
    [self writeInt:green bytesCount:1];
    [self writeInt:blue bytesCount:1];
    [self writeInt:blink bytesCount:1];
    return self;
}

- (instancetype)writeChecksumFromIndex:(NSUInteger)index length:(NSUInteger)length lastMACByte:(NSUInteger)lastMACByte {
    NSUInteger checksum = [MLHelper CRC8WithBytes:(_bytes + index) length:length];
    checksum ^= 0xff & lastMACByte;
    _bytes[_pos++] = checksum;
    return self;
}

- (NSData *)data {
    return [NSData dataWithBytes:_bytes length:_pos];
}

@end
