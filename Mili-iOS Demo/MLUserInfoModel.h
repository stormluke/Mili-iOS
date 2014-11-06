#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, MLGender) {
    ML_GENDER_FEMALE,
    ML_GENDER_MALE
};

typedef NS_ENUM(NSUInteger, MLAuthType) {
    ML_AUTH_NORMAL,
    ML_AUTH_CLEAR_DATA,
    ML_AUTH_RETAIN_DATA
};

@interface MLUserInfoModel : NSObject

@property (nonatomic) NSUInteger uid;
@property (nonatomic) MLGender gender;
@property (nonatomic) NSUInteger age;
@property (nonatomic) NSUInteger height;
@property (nonatomic) NSUInteger weight;
@property (nonatomic, strong) NSString *alias;
@property (nonatomic) MLAuthType type;

- (instancetype)initWithData:(NSData *)data;
- (NSData *)data;

@end
