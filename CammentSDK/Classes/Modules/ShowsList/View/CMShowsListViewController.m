//
//  CMShowsListCMShowsListViewController.m
//  Camment
//
//  Created by Alexander Fedosov on 19/05/2017.
//  Copyright 2017 Sportacam. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>
#import "CMShowsListViewController.h"
#import <ReactiveObjC/ReactiveObjC.h>
#import "CMStore.h"
#import "FBTweakViewController.h"
#import "FBTweakStore.h"

@interface CMShowsListViewController () <ASCollectionDelegate, FBTweakViewControllerDelegate>

@property (nonatomic, strong) NSString *broadcasterPasscode;

@end

@implementation CMShowsListViewController

- (instancetype)init {
    self = [super initWithNode:[CMShowsListNode new]];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
#ifdef INTERNALBUILD
    UIBarButtonItem *tweaksButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
                                                                            target:self
                                                                            action:@selector(showTweaks)];
    self.navigationItem.leftBarButtonItem = tweaksButton;
#endif
    
    UIBarButtonItem *passCodeButton = [[UIBarButtonItem alloc] initWithTitle:@"Passcode"
                                                                       style:UIBarButtonItemStylePlain
                                                                            target:self
                                                                            action:@selector(showPasscodeAlert)];
    self.navigationItem.rightBarButtonItem = passCodeButton;
    
    [[RACObserve([CMStore instance], isConnected) deliverOnMainThread] subscribeNext:^(NSNumber *isConnected) {
        self.title = isConnected.boolValue ? @"Shows" : @"...Connecting";
    }];
    [self.presenter setupView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)setCurrentBroadcasterPasscode:(NSString *)passcode {
    self.broadcasterPasscode = passcode;
}

- (void)setLoadingIndicator {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [hud setMode:MBProgressHUDModeIndeterminate];
    [hud setAnimationType:MBProgressHUDAnimationFade];
}

- (void)hideLoadingIndicator {
    [MBProgressHUD hideHUDForView:self.view animated:NO];
}


- (void)setCammentsBlockNodeDelegate:(id <CMShowsListNodeDelegate>)delegate {
    [self.node setShowsListDelegate:delegate];
    [delegate setItemCollectionDisplayNode:self.node];
}

- (BOOL)shouldAutorotate {
    return NO;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskPortrait;
}

- (void)showTweaks {
    FBTweakViewController *tweakVC = [[FBTweakViewController alloc] initWithStore:[FBTweakStore sharedInstance]];
    tweakVC.tweaksDelegate = self;
    [self presentViewController:tweakVC animated:YES completion:nil];
}

- (void)tweakViewControllerPressedDone:(FBTweakViewController *)tweakViewController {
    [tweakViewController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)showPasscodeAlert {
    UIAlertController *alertViewController = [UIAlertController alertControllerWithTitle:@"Enter passcode" message:@"" preferredStyle:UIAlertControllerStyleAlert];
    [alertViewController addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.text = self.broadcasterPasscode;
    }];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"OK"
                                                       style:UIAlertActionStyleDefault
                                                     handler:^(UIAlertAction *action) {
                                                         UITextField *textField = [alertViewController.textFields firstObject];
                                                         NSString *passcode = textField.text;
                                                         self.broadcasterPasscode = passcode;
                                                         [[self presenter] updateShows:passcode];
                                                     }];
    [alertViewController addAction:okAction];
    [self presentViewController:alertViewController animated:YES completion:nil];
}


@end
