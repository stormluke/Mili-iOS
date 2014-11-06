#import "MLBatteryInfoModel.h"
#import "MLHelper.h"

@implementation MLBatteryInfoModel

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        MLDataReader *reader = [[MLDataReader alloc] initWithData:data];
        _level = [reader readInt:1];
        _lastCharge = [reader readDate];
        _chargesCount = [reader readInt:2];
        _status = [reader readInt:1];
    }
    return self;
}

- (NSData *)data {
    MLDataBuilder *builder = [[MLDataBuilder alloc] init];
    [builder writeInt:_level bytesCount:1];
    [builder writeDate:_lastCharge];
    [builder writeInt:_chargesCount bytesCount:1];
    [builder writeInt:_status bytesCount:1];
    return [builder data];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"level = %tu%%, lastCharge = %@, chargesCount = %tu, status = %tx", _level, _lastCharge, _chargesCount, _status];
}

@end
