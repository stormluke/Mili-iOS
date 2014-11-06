#import "MLUserInfoModel.h"
#import "MLHelper.h"

@implementation MLUserInfoModel

- (instancetype)initWithData:(NSData *)data {
    self = [super init];
    if (self) {
        MLDataReader *reader = [[MLDataReader alloc] initWithData:data];
        _uid = [reader readInt:4];
        _gender = (MLGender)[reader readInt:1];
        _age = [reader readInt:1];
        _height = [reader readInt:1];
        _weight = [reader readInt:1];
        _alias = [[reader rePos:9] readString:10];
    }
    return self;
}

- (NSData *)data {
    MLDataBuilder *builder = [[MLDataBuilder alloc] init];
    [builder writeInt:_uid bytesCount:4];
    [builder writeInt:_gender bytesCount:1];
    [builder writeInt:_age bytesCount:1];
    [builder writeInt:_height bytesCount:1];
    [builder writeInt:_weight bytesCount:1];
    [builder writeInt:_type bytesCount:1];
    [builder writeString:_alias bytesCount:10];
    [builder writeChecksumFromIndex:0 length:19 lastMACByte:0xd5];
    return [builder data];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"uid = %tu, gender = %tu, age = %tu, height = %tu cm, weight = %tu kg, alias = %@, type = %tu", _uid, _gender, _age, _height, _weight, _alias, _type];
}

@end
