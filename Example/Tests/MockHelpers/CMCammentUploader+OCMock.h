//
//  CMCammentUploader+OCMock.h
//  CammentSDK-Unit-Tests
//
//  Created by Alexander Fedosov on 15.11.2017.
//

#import <CammentSDK/CMCammentUploader.h>

@interface CMCammentUploader (OCMock)

+ (CMCammentUploader *)mock_workingCammentUploader;
@end
