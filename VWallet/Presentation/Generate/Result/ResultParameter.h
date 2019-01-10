//
//  ResultParameter.h
//  Wallet
//
//  All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void(^VResultBlock)(void);

@interface ResultParameter : NSObject

@property (nonatomic, copy) NSString *imgResourceName;
@property (nonatomic, copy) NSString *resultTitle;
@property (nonatomic, copy) NSString *resultMessage;

+ (instancetype)paramterWithImgResourceName:(NSString *)imgResourceName
                                      title:(NSString *)title
                                    message:(NSString *)message;

@property (nonatomic, copy) NSString *operateBtnTitle;
@property (nonatomic, strong) VResultBlock operateBlock;
@property (nonatomic, copy) NSString *secondOperateBtnTitle;
@property (nonatomic, strong) VResultBlock secondOperateBlock;

@property (nonatomic, assign) BOOL explicitDismiss;

@end

NS_ASSUME_NONNULL_END
