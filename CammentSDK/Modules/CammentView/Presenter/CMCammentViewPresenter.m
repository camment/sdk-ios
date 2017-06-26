//
//  CMCammentViewCMCammentViewPresenter.m
//  CammentSDK
//
//  Created by Alexander Fedosov on 20/06/2017.
//  Copyright 2017 Camment. All rights reserved.
//

#import <ReactiveObjC/ReactiveObjC.h>
#import "CMCammentViewPresenter.h"
#import "CMCammentViewWireframe.h"
#import "CMInvitationWireframe.h"
#import "CMPresentationInstructionOutput.h"
#import "CMPresentationPlayerInteractor.h"
#import "CMCammentsBlockPresenter.h"
#import "Show.h"
#import "CMStore.h"
#import "CMCammentRecorderInteractorInput.h"
#import "CMPresentationState.h"
#import "CMCammentsLoaderInteractorInput.h"
#import "FBTweakStore.h"
#import "FBTweakCategory.h"
#import "FBTweakCollection.h"
#import "FBTweak.h"
#import "CMPresentationBuilder.h"
#import "CMPresentationUtility.h"
#import "CMCammentUploader.h"
#import "CMCammentInRequest.h"
#import "CMDevcammentClient.h"
#import "CMAuthInteractor.h"
#import "CammentSDK.h"
#import <FBSDKAccessToken.h>
#import <DateTools/DateTools.h>

@interface CMCammentViewPresenter () <CMPresentationInstructionOutput, CMAuthInteractorOutput>
@property(nonatomic, strong) CMPresentationPlayerInteractor *presentationPlayerInteractor;
@property(nonatomic, strong) CMAuthInteractor *authInteractor;
@property(nonatomic, strong) CMCammentsBlockPresenter *cammentsBlockNodePresenter;
@property(nonatomic, strong) Show *show;

@end

@implementation CMCammentViewPresenter

- (instancetype)initWithShow:(Show *)show {
    self = [super init];

    if (self) {
        self.show = show;
        self.cammentsBlockNodePresenter = [CMCammentsBlockPresenter new];
        self.presentationPlayerInteractor = [CMPresentationPlayerInteractor new];
        self.authInteractor = [CMAuthInteractor new];
        self.authInteractor.output = self;
        self.presentationPlayerInteractor.instructionOutput = self;

        __weak typeof(self) weakSelf = self;
        [RACObserve([CMStore instance], playingCammentId) subscribeNext:^(NSString *nextId) {
            [weakSelf playCamment:nextId];
        }];

        [[[RACObserve([CMStore instance], cammentRecordingState) filter:^BOOL(NSNumber *state) {
            return state.integerValue != CMCammentRecordingStateNotRecording;
        }] flattenMap:^RACSignal *(NSNumber *state) {
            typeof(self) strongSelf = weakSelf;
            if (!strongSelf) {return [RACSignal empty];}
            CMCammentRecordingState cammentRecordingState = (CMCammentRecordingState) state.integerValue;

            if (cammentRecordingState == CMCammentRecordingStateFinished) {
                [self.recorderInteractor stopRecording];
                return [RACSignal empty];
            }

            if (cammentRecordingState == CMCammentRecordingStateCancelled) {
                [[CMStore instance] setPlayingCammentId:kCMStoreCammentIdIfNotPlaying];
                [self.recorderInteractor cancelRecording];
                return [RACSignal empty];
            }

            return [[RACSignal createSignal:^RACDisposable *(id <RACSubscriber> subscriber) {
                [subscriber sendNext:@YES];
                return nil;
            }] delay:0.0f];
        }] subscribeNext:^(id x) {
            [[CMStore instance] setPlayingCammentId:kCMStoreCammentIdIfNotPlaying];
            [self.recorderInteractor startRecording];
        }];

        [[RACSignal combineLatest:@[
                RACObserve(self, cammentsBlockNodePresenter.items),
                RACObserve([CMStore instance], currentShowTimeInterval)
        ]] subscribeNext:^(RACTuple *tuple) {
            typeof(self) strongSelf = weakSelf;
            if (!strongSelf) {return;}
            CMPresentationState *state = [CMPresentationState new];
            state.items = tuple.first;
            state.timestamp = [tuple.second unsignedIntegerValue];
            [strongSelf.presentationPlayerInteractor update:state];
        }];
    }

    return self;
}

- (void)setupView {
    [self.recorderInteractor configureCamera];
    [self.output presenterDidRequestViewPreviewView];
    [self.output setCammentsBlockNodeDelegate:_cammentsBlockNodePresenter];
    [self.loaderInteractor fetchCachedCamments:_show.uuid];
    [self setupPresentationInstruction];
}

- (void)updateCameraOrientation:(enum AVCaptureVideoOrientation)orientation {
    [self.recorderInteractor updateDeviceOrientation:orientation];
}

- (UIInterfaceOrientationMask)contentPossibleOrientationMask {
    __block UIInterfaceOrientationMask mask;

    [self.show.showType matchVideo:^(CMShow *show) {
        mask = UIInterfaceOrientationMaskLandscapeRight;
    }                         html:^(NSString *webURL) {
        mask = UIInterfaceOrientationMaskPortrait;
    }];

    return mask;
}

- (void)setupPresentationInstruction {
    NSString *scenario = [[[[[FBTweakStore sharedInstance] tweakCategoryWithName:@"Predefined stuff"] tweakCollectionWithName:@"Demo"] tweakWithIdentifier:@"Scenario"] currentValue] ?: @"None";

    id <CMPresentationBuilder> builder = nil;

    NSArray<id <CMPresentationBuilder>> *presentations = [CMPresentationUtility activePresentations];
    for (id <CMPresentationBuilder> presentation in presentations) {
        if ([[presentation presentationName] isEqualToString:scenario]) {
            builder = presentation;
        }
    }

    if (!builder) {
        return;
    }
    self.presentationPlayerInteractor.instructions = [builder instructions];
}

- (void)reloadCamments {
    [_cammentsBlockNodePresenter.collectionNode reloadData];
}

- (void)didFetchCamments:(NSArray<Camment *> *)camments {
    _cammentsBlockNodePresenter.items = [camments.rac_sequence map:^id(Camment *value) {
        return [CammentsBlockItem cammentWithCamment:value];
    }].array;
    [self reloadCamments];
}

- (void)playCamment:(NSString *)cammentId {
    [_cammentsBlockNodePresenter playCamment:cammentId];
}

- (void)connectPreviewViewToRecorder:(SCImageView *)view {
    [_recorderInteractor connectPreviewViewToRecorder:view];
}

- (void)recorderDidFinishAVAsset:(AVAsset *)asset uuid:(NSString *)uuid {
    if (asset) {
        if (CMTimeGetSeconds(asset.duration) < 0.3) {return;}
        NSString *cammentId = [NSUUID new].UUIDString;
        Camment *camment = [[Camment alloc] initWithShowUUID:_show.uuid
                                                 cammentUUID:cammentId
                                                   remoteURL:nil
                                                    localURL:nil
                                                  localAsset:asset
                                               temporaryUUID:uuid];
        [self.cammentsBlockNodePresenter insertNewItem:[CammentsBlockItem cammentWithCamment:camment]];
    }
}

- (void)recorderDidFinishExportingToURL:(NSURL *)url uuid:(NSString *)uuid {
    [[[[CMCammentUploader instance] uploadVideoAsset:url
                                                uuid:uuid] deliverOnMainThread] subscribeCompleted:^{
        CMCammentInRequest *cammentInRequest = [[CMCammentInRequest alloc] init];
        cammentInRequest.url = [NSString stringWithFormat:@"https://s3.eu-central-1.amazonaws.com/sportacam-temp/%@.mp4", uuid];
        NSMutableArray<CammentsBlockItem *> *mutableCamments = [self.cammentsBlockNodePresenter.items mutableCopy];
        NSInteger index = [self.cammentsBlockNodePresenter.items indexOfObjectPassingTest:^BOOL(CammentsBlockItem *obj, NSUInteger idx, BOOL *_Nonnull stop) {
            __block BOOL result = NO;

            [obj matchCamment:^(Camment *camment) {
                result = [camment.temporaryUUID isEqualToString:uuid];
            }             ads:^(Ads *ads) {
            }];

            return result;
        }];
        if (index != NSNotFound) {
            CammentsBlockItem *cammentsBlockItem = mutableCamments[(NSUInteger) index];
            [cammentsBlockItem matchCamment:^(Camment *camment) {
                Camment *updateCamment = [[Camment alloc] initWithShowUUID:camment.showUUID
                                                               cammentUUID:camment.cammentUUID
                                                                 remoteURL:cammentInRequest.url
                                                                  localURL:camment.localURL
                                                                localAsset:camment.localAsset
                                                             temporaryUUID:camment.temporaryUUID];
                mutableCamments[(NSUInteger) index] = [CammentsBlockItem cammentWithCamment:updateCamment];
            }                           ads:^(Ads *ads) {
            }];
        }
        self.cammentsBlockNodePresenter.items = mutableCamments.copy;

        [[[CMDevcammentClient defaultClient] showsUuidCammentsPost:self.show.uuid
                                                              body:cammentInRequest]
                continueWithBlock:^id(AWSTask<CMCamment *> *t) {
                    return nil;
                }];
    }];
}

- (void)didReceiveNewCamment:(Camment *)camment {

    NSArray *filteredItemsArray = [self.cammentsBlockNodePresenter.items.rac_sequence filter:^BOOL(CammentsBlockItem *value) {
        __block BOOL result = NO;

        [value matchCamment:^(Camment *mathedCamment) {
            result = [camment.remoteURL isEqualToString:mathedCamment.remoteURL];
        }               ads:^(Ads *ads) {
        }];

        return result;
    }].array ?: @[];

    BOOL isNewItem = filteredItemsArray.count == 0;

    if (([camment.showUUID isEqualToString:_show.uuid]
            || [camment.showUUID isEqualToString:kCMPresentationBuilderUtilityAnyShowUUID])
            && isNewItem) {
        [self.cammentsBlockNodePresenter insertNewItem:[CammentsBlockItem cammentWithCamment:camment]];
    }
}

- (void)didReceiveNewAds:(Ads *)ads {
    [self.cammentsBlockNodePresenter insertNewItem:[CammentsBlockItem adsWithAds:ads]];
}

- (void)inviteFriendsAction {
    FBSDKAccessToken *token = [FBSDKAccessToken currentAccessToken];
    [CMStore instance].isFBConnected = token != nil && [token.expirationDate laterDate:[NSDate date]];
    if ([CMStore instance].isFBConnected) {
        [[CMInvitationWireframe new] presentInViewController:self.wireframe.parentViewController];
    } else {
        [self.output setDisplayWaitingHUD:YES];
        [_authInteractor signInWithFacebookProvider:(id) self.output];
    }
}

- (void)authInteractorDidSignedIn {
    CMCammentFacebookIdentity *fbIdentity = [CMCammentFacebookIdentity identityWithFBSDKAccessToken:[FBSDKAccessToken currentAccessToken]];
    [[CammentSDK instance] connectUserWithIdentity:fbIdentity
                                           success:^{
                                               [self.output setDisplayWaitingHUD:NO];
                                               [self inviteFriendsAction];
                                           }
                                             error:^(NSError *error) {
                                                 [self.output setDisplayWaitingHUD:NO];
                                                 NSLog(@"Error %@", error);
                                             }];
}

- (void)authInteractorFailedToSignIn:(NSError *)error {
    [self.output setDisplayWaitingHUD:NO];
    NSLog(@"Error %@", error);
}

@end
