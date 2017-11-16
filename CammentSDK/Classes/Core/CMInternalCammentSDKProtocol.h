//
// Created by Alexander Fedosov on 24.10.2017.
//

#import <Foundation/Foundation.h>
#import "CammentSDK.h"

@protocol CMInternalCammentSDKProtocol <NSObject>

- (void)renewUserIdentitySuccess:(void (^ _Nullable)(void))successBlock
                           error:(void (^ _Nullable)(NSError * _Nullable error))errorBlock;

- (DDFileLogger *)getFileLogger;

-  (void)openURL:(NSURL *)url;

@end
