#import <Foundation/Foundation.h>

@interface MLDeviceInfoModel : NSObject

@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *profileVersion;
@property (nonatomic, strong) NSString *firmwareVersion;
@property (nonatomic) NSUInteger feature;
@property (nonatomic) NSUInteger appearence;
@property (nonatomic) NSUInteger hardwareVersion;

- (instancetype)initWithData:(NSData *)data;
- (NSData *)data;

@end
