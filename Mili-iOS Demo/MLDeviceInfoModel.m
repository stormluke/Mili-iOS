#import "MLDeviceInfoModel.h"
#import "MLHelper.h"

@implementation MLDeviceInfoModel

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        MLDataReader *reader = [[MLDataReader alloc] initWithData:data];
        _feature = [[reader rePos:4] readInt:1];
        _appearence = [reader readInt:1];
        _hardwareVersion = [reader readInt:1];
        _deviceID = @"";
        [reader rePos:0];
        for (NSUInteger i = 0; i < 8; i++) {
            Byte byte = [reader readInt:1];
            _deviceID = [_deviceID stringByAppendingString:[MLHelper byte2HexString:byte]];
        }
        _profileVersion = [reader readVersionString];
        _firmwareVersion = [reader readVersionString];
    }
    return self;
}

- (NSData *)data {
    MLDataBuilder *builder = [[MLDataBuilder alloc] init];
    [builder writeString:_deviceID bytesCount:8];
    [builder writeVersionString:_profileVersion];
    [builder writeVersionString:_firmwareVersion];
    return [builder data];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"deviceID = %@, profileVersion = %@, firmwareVersion = %@, feature = %tu, appearence = %tu, hardwareVersion = %tu", _deviceID, _profileVersion, _firmwareVersion, _feature, _appearence, _hardwareVersion];
}

@end
