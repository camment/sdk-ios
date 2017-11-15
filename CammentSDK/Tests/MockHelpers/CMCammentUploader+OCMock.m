//
//  CMCammentUploader+OCMock.m
//  CammentSDK-Unit-Tests
//
//  Created by Alexander Fedosov on 15.11.2017.
//

#import "CMCammentUploader+OCMock.h"
#import <OCMock/OCMock.h>
#import <ReactiveObjC/ReactiveObjC.h>

@implementation CMCammentUploader (OCMock)

+ (CMCammentUploader *)mock_workingCammentUploader {
    CMCammentUploader *cammentUploader = OCMClassMock([CMCammentUploader class]);
    // Mock camment uploaded successfully
    RACSignal *uploadingResult = [RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
        [subscriber sendCompleted];
        return nil;
    }];
    OCMStub([cammentUploader uploadVideoAsset:OCMOCK_ANY uuid:OCMOCK_ANY])
            .andReturn(uploadingResult);
    return cammentUploader;
}

@end
