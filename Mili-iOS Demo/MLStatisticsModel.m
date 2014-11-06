#import "MLStatisticsModel.h"
#import "MLHelper.h"

@implementation MLStatisticsModel

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        MLDataReader *reader = [[MLDataReader alloc] initWithData:data];
        _wake = [reader readInt:4];
        _vibrate = [reader readInt:4];
        _light = [reader readInt:4];
        _conn = [reader readInt:4];
        _adv = [reader readInt:4];
    }
    return self;
}

- (NSData *)data {
    MLDataBuilder *builder = [[MLDataBuilder alloc] init];
    [builder writeInt:_wake bytesCount:4];
    [builder writeInt:_vibrate bytesCount:4];
    [builder writeInt:_light bytesCount:4];
    [builder writeInt:_conn bytesCount:4];
    [builder writeInt:_adv bytesCount:4];
    return [builder data];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"wake = %tu(%tu) ms, vibrate = %tu ms, light = %tu ms, conn = %tu ms, adv = %tu ms", (NSUInteger)(_wake / 1.6), _wake, _vibrate, _light, _conn, _adv];
}

@end
