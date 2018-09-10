//
//  CMSofaInteractor.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 29/08/2018.
//

#import <Foundation/Foundation.h>
#import <Bolts/Bolts.h>


@interface CMSofaInteractor : NSObject

- (BFTask *)fetchSofaViewForShow:(NSString *)uuid;

@end
