//
//  Language.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define VLocalize(str) [[Language shareInstance] getString:str]

typedef NS_ENUM(NSInteger, LanguageType) {
    LanguageTypeCN = 0,
    LanguageTypeEN
};

@interface Language : NSObject

@property (nonatomic, assign) NSString *lan;

@property (nonatomic, assign) LanguageType languageType;

+ (instancetype)shareInstance;

- (NSString *)getString:(NSString *)key;

+ (NSArray *)supportLanguages;

@end

NS_ASSUME_NONNULL_END
