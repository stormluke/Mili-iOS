#import "MLLEParamsModel.h"
#import "MLHelper.h"

@implementation MLLEParamsModel

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        MLDataReader *reader = [[MLDataReader alloc] initWithData:data];
        _connIntMin = [reader readInt:2];
        _connIntMax = [reader readInt:2];
        _latency = [reader readInt:2];
        _timeout = [reader readInt:2];
        _connInt = [reader readInt:2];
        _advInt = [reader readInt:2];
    }
    return self;
}

- (NSData *)data {
    MLDataBuilder *builder = [[MLDataBuilder alloc] init];
    [builder writeInt:_connIntMin bytesCount:2];
    [builder writeInt:_connIntMax bytesCount:2];
    [builder writeInt:_latency bytesCount:2];
    [builder writeInt:_timeout bytesCount:2];
    [builder writeInt:_connInt bytesCount:2];
    [builder writeInt:_advInt bytesCount:2];
    return [builder data];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"connIntMin = %tu(%tu) ms, connIntMax = %tu(%tu) ms, latency = %tu ms, timeout = %tu(%tu) ms, connInt = %tu(%tu) ms, advInt = %tu(%tu) ms", (NSUInteger)(_connIntMin * 1.25), _connIntMin, (NSUInteger)(_connIntMax * 1.25), _connIntMax, _latency, _timeout * 10, _timeout, (NSUInteger)(_connInt * 1.25), _connInt, (NSUInteger)(_advInt * 0.625), _advInt];
}

@end
