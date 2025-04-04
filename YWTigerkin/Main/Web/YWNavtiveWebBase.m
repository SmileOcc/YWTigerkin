//
//  YWNavtiveWebBase.m
//  YWTigerkin
//
//  Created by 欧冬冬 on 2025/4/4.
//

#import "YWNavtiveWebBase.h"

@implementation YWNavtiveWebBase

//将此View作为原生组件的容器，渲染到WebView中，即可实现原生组件的事件交互。
- (BOOL)conformsToProtocol:(Protocol *)aProtocol {
    if (aProtocol == NSProtocolFromString(@"WKNativelyInteractible")) {
        return YES;
    }
    return [super conformsToProtocol:aProtocol];
}

@end
