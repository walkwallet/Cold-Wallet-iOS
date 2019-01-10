//
//  ResultParameter.m
//  Wallet
//
//  All rights reserved.
//

#import "ResultParameter.h"

@implementation ResultParameter

+ (instancetype)paramterWithImgResourceName:(NSString *)imgResourceName title:(NSString *)title message:(NSString *)message {
    ResultParameter *parameter = [[ResultParameter alloc] init];
    parameter.imgResourceName = imgResourceName;
    parameter.resultTitle = title;
    parameter.resultMessage = message;
    return parameter;
}

@end
