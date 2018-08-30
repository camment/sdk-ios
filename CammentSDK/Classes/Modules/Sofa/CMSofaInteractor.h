//
//  CMSofaInteractor.h
//  CammentSDK
//
//  Created by Alexander Fedosov on 29/08/2018.
//

#import <Foundation/Foundation.h>
#import "CMAPISofa.h"

@protocol CMSofaInteractorOutput<NSObject>

- (void)sofaViewDidFetchedContent:(CMAPISofa *)sofa;
- (void)sofaViewDidFailedFetching:(NSError *)error;

@end


@interface CMSofaInteractor : NSObject

@property (nonatomic, weak) id<CMSofaInteractorOutput> output;

- (void)fetchSofaViewForShow:(NSString *)uuid;

@end
