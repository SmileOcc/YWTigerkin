//
//  YWExceptionOCCatch.m
//  YWTigerkin
//
//  Created by odd on 11/2/24.
//

#import "YWExceptionOCCatch.h"

@implementation YWExceptionOCCatch

+ (BOOL)catchException:(__attribute__((noescape)) void(^)(void))tryBlock error:(__autoreleasing NSError **)error {
    @try {
        tryBlock();
        return YES;
    } @catch (NSException *exp) {
        *error = [[NSError alloc] initWithDomain:exp.name code:-1000 userInfo:@{
            NSUnderlyingErrorKey: exp,
            NSLocalizedDescriptionKey: exp.reason,
            @"CallStackSymbols": exp.callStackSymbols
        }];

        return NO;
    }
}

@end
