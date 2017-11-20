//
//  CMAPIDevcammentClient+OCMock.h
//  CammentSDK-Unit-Tests
//
//  Created by Alexander Fedosov on 14.11.2017.
//

#import "CMAPIDevcammentClient.h"
#import <OCMock/OCMock.h>

@interface CMAPIDevcammentClient (OCMock)

+ (CMAPIDevcammentClient *)mock_workingApiClient;
@end
