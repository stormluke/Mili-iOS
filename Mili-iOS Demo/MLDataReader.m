#import "MLDataReader.h"

@implementation MLDataReader

- (instancetype)init {
    self = [super init];
    if (self) {
        _bytes = [NSMutableData dataWithLength:0].mutableBytes;
        _length = 0;
    }
    return self;
}

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        _bytes = (Byte *)data.bytes;
        _length = data.length;
    }
    return self;
}

- (instancetype)appendData:(NSData *)data {
    NSMutableData *temp = [NSMutableData dataWithBytes:_bytes length:_length];
    [temp appendData:data];
    _bytes = temp.mutableBytes;
    _length = temp.length;
    return self;
}

- (instancetype)rePos:(NSUInteger)pos {
    _pos = pos;
    return self;
}

- (NSUInteger)bytesLeftCount {
    return _length - _pos;
}

- (NSUInteger)readInt:(NSUInteger)bytesCount {
    NSUInteger result = 0;
    for (int i = 0; i < bytesCount; i++) {
        result |= _bytes[_pos++] << (i * 8);
    }
    return result;
}

- (NSInteger)readSensorData {
    NSInteger temp = [self readInt:2] & 0xfff;
    if (temp & 0x800) {
        temp -= 0x1000;
    }
    return temp;
}

- (NSString *)readString:(NSUInteger)bytesCount {
    return [[[NSString alloc] initWithBytes:(_bytes + _pos) length:bytesCount encoding:NSUTF8StringEncoding] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (NSString *)readVersionString {
    _pos += 4;
    return [NSString stringWithFormat:@"%d.%d.%d.%d", _bytes[_pos - 1], _bytes[_pos - 2], _bytes[_pos - 3], _bytes[_pos - 4]];
}

- (NSDate *)readDate {
    NSInteger year = _bytes[_pos++] + 2000;
    NSInteger month = _bytes[_pos++] + 1;
    NSInteger day = _bytes[_pos++];
    NSInteger hour = _bytes[_pos++];
    NSInteger minute = _bytes[_pos++];
    NSInteger second = _bytes[_pos++];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    return [calendar dateWithEra:year/100 year:year month:month day:day hour:hour minute:minute second:second nanosecond:0];
}

- (NSString *)readMACAddressString {
    _pos += 6;
    return [NSString stringWithFormat:@"%02tx:%02tx:%02tx:%02tx:%02tx:%02tx", _bytes[_pos - 6], _bytes[_pos - 5], _bytes[_pos - 4], _bytes[_pos - 3], _bytes[_pos - 2], _bytes[_pos - 1]];
}

@end
