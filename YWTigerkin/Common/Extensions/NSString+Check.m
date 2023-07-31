//
//  NSString+Check.m
//  YWTigerkin
//
//  Created by odd on 7/28/23.
//

#import "NSString+Check.h"

@implementation NSString (Check)

- (BOOL)includeChinese
{
    for(int i=0; i< [self length];i++)
    {
        int a =[self characterAtIndex:i];
        if( a >0x4e00&& a <0x9fff){
            return YES;
        }
    }
    return NO;
}
@end
