//
// Created by Alexander Fedosov on 02.08.17.
// Copyright (c) 2017 Camment. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "CMEmailSubscriptionViewController.h"
#import "CMStore.h"


@interface CMEmailSubscriptionViewController () <UIWebViewDelegate>

@property(nonatomic, strong) UIWebView *webView;
@property(nonatomic, strong) NSDictionary<NSString *, NSArray<id<CMPresentationRunableInterface>> *> * actions;
@property(nonatomic, weak) id <CMPresentationInstructionOutput> output;

@end

@implementation CMEmailSubscriptionViewController {

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.webView = [[UIWebView alloc] init];
    NSString* htmlPath = [[NSBundle cammentSDKBundle] pathForResource:@"emailform" ofType:@"html"];
    NSString *html = [NSString stringWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:NULL];
    html = [html stringByReplacingOccurrencesOfString:@"${email}" withString:@""];

    [self.webView loadHTMLString:html baseURL:nil];
    self.webView.delegate = self;
    [self.view addSubview:_webView];
}

- (void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.webView.frame = self.view.bounds;
}

- (void)presentWithOutput:(id <CMPresentationInstructionOutput>)output
                  actions:(NSDictionary<NSString *, NSArray<id <CMPresentationRunableInterface>> *> *)actions
{
    self.output = output;
    self.actions = actions;
    [output presentationInstruction:nil
             presentsViewController:[[UINavigationController alloc] initWithRootViewController:self]];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    NSString *url = request.URL.absoluteString;
    
    if ([url hasPrefix:@"action://cancel"]) {
        [self dismissViewControllerAnimated:YES completion:^{}];
        return NO;
    }
    
    if ([url hasPrefix:@"action://subscribe"]) {
        NSArray<id <CMPresentationRunableInterface>> *runable= self.actions[@"subscribe"];
        [self dismissViewControllerAnimated:YES completion:^{
            for (id<CMPresentationRunableInterface> r in runable) {
                [r runWithOutput:self.output];
            }
        }];
        return NO;
    }
    
    return YES;
}
@end
